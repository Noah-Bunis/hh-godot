extends SGCharacterBody2D

class_name BasePlayer

var Hitbox1
var Hitbox2
var Hurtbox1
var Hurtbox2
var Hurtbox3

@onready var _shader_mat = get_node("Sprite2D").material

signal strike_hurt (damage, hitCount, invalid, block, guard)

signal attack_hurt(hitbox_name)

signal combo_exit () # invalid combo

signal super_freeze (x, y, leftface)

signal projectilespawn(x, y,node_to_spawn, node_name, player_setup)

# Fields
var team: bool
var currentState: Dictionary = {} # Rollback compliant state local reference
var fighterState: PersistentState
var input_interpreter: InputInterpreter

var old_super_meter: int = 0
var old_assist_meter: int = 0

var assist_meter_build_frozen: bool = false

var color_scheme = null

var attackData: Dictionary = {
	Enums.StKey.attack_type: Enums.AttackType.Strike,
	Enums.StKey.hitstop: Util.DEFAULT_HITSTOP,
	Enums.StKey.attack_damage: 50,
	Enums.StKey.hitstun: Util.DEFAULT_HITSTUN,
	Enums.StKey.blockstun: Util.DEFAULT_BLOCKSTUN,
	Enums.StKey.chip_damage: 0,
	Enums.StKey.min_damage: 2,
	Enums.StKey.burst_OK: true,
	Enums.StKey.meter_build: SGFixed.ONE*500,
	Enums.StKey.hit_box_colliding_frame: 1000,
	Enums.StKey.guard: Enums.GuardType.Mid,
	Enums.StKey.counter_hit: Enums.AttackType.Launcher,
	Enums.StKey.counter_hitstun: 2,
	Enums.StKey.block_dir_x: -SGFixed.ONE*30,
	Enums.StKey.block_dir_y: -SGFixed.ONE*30,
	Enums.StKey.launch_dir_x: -SGFixed.ONE*7,
	Enums.StKey.launch_dir_y: -SGFixed.ONE*30,
	Enums.StKey.counter_launch_dir_x: -SGFixed.ONE*7,
	Enums.StKey.counter_launch_dir_y: -SGFixed.ONE*30,
}

func _init():
	add_to_group("fight_entity")
	add_to_group("network_sync")

func reset_to_game_start():
	Util.reset_node_transform_state(self)
	currentState[Enums.StKey.stateName] = "Neutral"
	currentState[Enums.StKey.next_state] = "Neutral"
	currentState[Enums.StKey.transition_state_flag] = false
	currentState[Enums.StKey.velocity_x] = 0
	currentState[Enums.StKey.velocity_y] = 0
	currentState[Enums.StKey.accel_x] = 0
	currentState[Enums.StKey.accel_y] = 0
	currentState[Enums.StKey.drag_x] = 0
	currentState[Enums.StKey.modify_x] = 0
	currentState[Enums.StKey.leftface] = false
	currentState[Enums.StKey.leftfaceOK] = true
	currentState[Enums.StKey.frame] = 0
	currentState[Enums.StKey.last_anim_frame] = 0
	currentState[Enums.StKey.hitStopFrame] = -1
	currentState[Enums.StKey.hit_box_colliding_frame] = -1
	currentState[Enums.StKey.cancelState] = ""
	currentState[Enums.StKey.hitstun] = 0
	currentState[Enums.StKey.hitCount] = 0
	currentState[Enums.StKey.comboTime] = 0
	currentState[Enums.StKey.doubleJump] = 1
	currentState[Enums.StKey.airDash] = 1
	currentState[Enums.StKey.ground_bounce] = 0
	currentState[Enums.StKey.wall_bounce] = 0
	currentState[Enums.StKey.counterOK] = true
	currentState[Enums.StKey.assist_meter] = Util.ASSIST_STOCK*2-(SGFixed.ONE*5000)
	currentState[Enums.StKey.sync_rate] = Util.BASE_SYNC_RATE
	currentState[Enums.StKey.old_sync_rate] = Util.BASE_SYNC_RATE
	currentState[Enums.StKey.super_meter] = Util.LEVEL_ONE_SUPER
	currentState[Enums.StKey.opponent_pos_x] = 0
	currentState[Enums.StKey.distance_to_opponent] = 0
	currentState[Enums.StKey.hit_cooldown] = {}
	reset_hitboxes()
	if (fighterState != null):
		fighterState.update_rollback_state(currentState)
		fighterState.rollback_state_transition(currentState.get(Enums.StKey.stateName, "Neutral"))
	sync_to_physics_engine()

func reset_hitboxes():
	if (Hitbox1 != null):
		Hitbox1.reset_to_game_start()
		Hitbox2.reset_to_game_start()
		Hurtbox1.reset_to_game_start()
		Hurtbox2.reset_to_game_start()
		Hurtbox3.reset_to_game_start()

func _ready():
	reset_to_game_start()

func _save_state() -> Dictionary:
	var state = {
		Enums.StKey.stateName : currentState.get(Enums.StKey.stateName, "Neutral"),
		Enums.StKey.next_state : currentState.get(Enums.StKey.next_state, "Neutral"),
		Enums.StKey.transition_state_flag : currentState.get(Enums.StKey.transition_state_flag, false),
		Enums.StKey.velocity_x : currentState.get(Enums.StKey.velocity_x, 0),
		Enums.StKey.velocity_y : currentState.get(Enums.StKey.velocity_y, 0),
		Enums.StKey.accel_x : currentState.get(Enums.StKey.accel_x, 0),
		Enums.StKey.accel_y : currentState.get(Enums.StKey.accel_y, 0),
		Enums.StKey.drag_x : currentState.get(Enums.StKey.drag_x, 0),
		Enums.StKey.modify_x : currentState.get(Enums.StKey.modify_x, 0), # think dash momentum + pushback
		Enums.StKey.leftface : currentState.get(Enums.StKey.leftface, false),
		Enums.StKey.leftfaceOK : currentState.get(Enums.StKey.leftfaceOK, true),
		Enums.StKey.frame : currentState.get(Enums.StKey.frame, 0),
		Enums.StKey.last_anim_frame : currentState.get(Enums.StKey.last_anim_frame, 0),
		Enums.StKey.hitStopFrame : currentState.get(Enums.StKey.hitStopFrame, -1),
		Enums.StKey.hit_box_colliding_frame : currentState.get(Enums.StKey.hit_box_colliding_frame, -1),
		Enums.StKey.cancelState : currentState.get(Enums.StKey.cancelState, ""),
		Enums.StKey.hitstun : currentState.get(Enums.StKey.hitstun, 0),
		Enums.StKey.hitCount : currentState.get(Enums.StKey.hitCount, 0),
		Enums.StKey.comboTime : currentState.get(Enums.StKey.comboTime, 0),
		Enums.StKey.doubleJump : currentState.get(Enums.StKey.doubleJump, 1),
		Enums.StKey.airDash : currentState.get(Enums.StKey.airDash, 1),
		Enums.StKey.ground_bounce : currentState.get(Enums.StKey.ground_bounce, 0),
		Enums.StKey.wall_bounce : currentState.get(Enums.StKey.wall_bounce, 0),
		Enums.StKey.counterOK : currentState.get(Enums.StKey.counterOK, false),
		Enums.StKey.assist_meter : currentState.get(Enums.StKey.assist_meter, 0),
		Enums.StKey.sync_rate : currentState.get(Enums.StKey.sync_rate, Util.BASE_SYNC_RATE),
		Enums.StKey.old_sync_rate : currentState.get(Enums.StKey.old_sync_rate, Util.BASE_SYNC_RATE),
		Enums.StKey.super_meter : currentState.get(Enums.StKey.super_meter, 0),
		Enums.StKey.opponent_pos_x : currentState.get(Enums.StKey.opponent_pos_x, 0),
		Enums.StKey.distance_to_opponent : currentState.get(Enums.StKey.distance_to_opponent, 0),
		Enums.StKey.hit_cooldown : currentState.get(Enums.StKey.hit_cooldown, {}).duplicate(),
	}
	Util.save_player_transform_state(self, state)
	return state

func _load_state(state: Dictionary) -> void:
	Util.load_node_transform_state(self, state)
	currentState[Enums.StKey.stateName] = state.get(Enums.StKey.stateName, "Neutral")
	currentState[Enums.StKey.next_state] = state.get(Enums.StKey.next_state, "Neutral")
	currentState[Enums.StKey.transition_state_flag] = state.get(Enums.StKey.transition_state_flag, false)
	currentState[Enums.StKey.velocity_x] = state.get(Enums.StKey.velocity_x, 0)
	currentState[Enums.StKey.velocity_y] = state.get(Enums.StKey.velocity_y, 0)
	currentState[Enums.StKey.accel_x] = state.get(Enums.StKey.accel_x, 0)
	currentState[Enums.StKey.accel_y] = state.get(Enums.StKey.accel_y, 0)
	currentState[Enums.StKey.drag_x] = state.get(Enums.StKey.drag_x, 0)
	currentState[Enums.StKey.modify_x] = state.get(Enums.StKey.modify_x, 0)
	currentState[Enums.StKey.leftface] = state.get(Enums.StKey.leftface, false)
	currentState[Enums.StKey.leftfaceOK] = state.get(Enums.StKey.leftfaceOK, true)
	currentState[Enums.StKey.frame] = state.get(Enums.StKey.frame, 0)
	currentState[Enums.StKey.last_anim_frame] = state.get(Enums.StKey.last_anim_frame, 0)
	currentState[Enums.StKey.hitStopFrame] = state.get(Enums.StKey.hitStopFrame, -1)
	currentState[Enums.StKey.hit_box_colliding_frame] = state.get(Enums.StKey.hit_box_colliding_frame, -1)
	currentState[Enums.StKey.cancelState] = state.get(Enums.StKey.cancelState, "")
	currentState[Enums.StKey.hitstun] = state.get(Enums.StKey.hitstun, 0)
	currentState[Enums.StKey.hitCount] = state.get(Enums.StKey.hitCount, 0)
	currentState[Enums.StKey.comboTime] = state.get(Enums.StKey.comboTime, 0)
	currentState[Enums.StKey.doubleJump] = state.get(Enums.StKey.doubleJump, 1)
	currentState[Enums.StKey.airDash] = state.get(Enums.StKey.airDash, 1)
	currentState[Enums.StKey.ground_bounce] = state.get(Enums.StKey.ground_bounce, 0)
	currentState[Enums.StKey.wall_bounce] = state.get(Enums.StKey.wall_bounce, 0)
	currentState[Enums.StKey.counterOK] = state.get(Enums.StKey.counterOK, true)
	currentState[Enums.StKey.assist_meter] = state.get(Enums.StKey.assist_meter, 0)
	currentState[Enums.StKey.sync_rate] = state.get(Enums.StKey.sync_rate, Util.BASE_SYNC_RATE)
	currentState[Enums.StKey.old_sync_rate] = state.get(Enums.StKey.old_sync_rate, Util.BASE_SYNC_RATE)
	currentState[Enums.StKey.super_meter] = state.get(Enums.StKey.super_meter, 0)
	currentState[Enums.StKey.opponent_pos_x] = state.get(Enums.StKey.opponent_pos_x, 0)
	currentState[Enums.StKey.distance_to_opponent] = state.get(Enums.StKey.distance_to_opponent, 0)
	currentState[Enums.StKey.hit_cooldown] = state.get(Enums.StKey.hit_cooldown, {}).duplicate()
	fighterState.update_rollback_state(currentState) # TODO: probably don't need this anymore
	fighterState.rollback_state_transition(currentState.get(Enums.StKey.stateName, "Neutral"))
	sync_to_physics_engine()

func _interpolate_state(old_state: Dictionary, new_state: Dictionary, weight: float) -> void:
	Util.interpolate_node_transform_state(self, old_state, new_state, weight)

#func queue_free(): TODO: how to free nodes?
	#super.queue_free()
	#fighterState.free_states()
	
func anim_updates() -> void:
	var anim_frame : Dictionary = fighterState.state.anim_data.get(currentState[Enums.StKey.frame], {})
	if (anim_frame.is_empty()):
		anim_frame = fighterState.state.anim_data.get(currentState[Enums.StKey.last_anim_frame], {})
	else:
		currentState[Enums.StKey.last_anim_frame] = currentState[Enums.StKey.frame]
	
	if (currentState[Enums.StKey.last_anim_frame] == currentState[Enums.StKey.frame]):
		if (anim_frame.get(Enums.StKey.hit_box_colliding_frame, -1) >= 0 and currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
			currentState[Enums.StKey.hit_box_colliding_frame] = anim_frame.get(Enums.StKey.hit_box_colliding_frame, 254)
			currentState[Enums.StKey.hit_cooldown] = {}
		Hitbox1.disable(anim_frame.get(Enums.StKey.Hit1Disable, true))
		Hitbox2.disable(anim_frame.get(Enums.StKey.Hit2Disable, true))
		
		Hurtbox1.disable(anim_frame.get(Enums.StKey.Hurt1Disable, true))
		Hurtbox2.disable(anim_frame.get(Enums.StKey.Hurt2Disable, true))
		Hurtbox3.disable(anim_frame.get(Enums.StKey.Hurt3Disable, true))
		
		Hitbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hit1PosX, Hitbox1.fixed_position.x)
		Hitbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hit1PosY, Hitbox1.fixed_position.y)
		Hitbox2.fixed_position.x = anim_frame.get(Enums.StKey.Hit2PosX, Hitbox2.fixed_position.x)
		Hitbox2.fixed_position.y = anim_frame.get(Enums.StKey.Hit2PosY, Hitbox2.fixed_position.y)
		
		Hurtbox1.fixed_position.x = anim_frame.get(Enums.StKey.Hurt1PosX, Hurtbox1.fixed_position.x)
		Hurtbox1.fixed_position.y = anim_frame.get(Enums.StKey.Hurt1PosY, Hurtbox1.fixed_position.y)
		Hurtbox2.fixed_position.x = anim_frame.get(Enums.StKey.Hurt2PosX, Hurtbox2.fixed_position.x)
		Hurtbox2.fixed_position.y = anim_frame.get(Enums.StKey.Hurt2PosY, Hurtbox2.fixed_position.y)
		Hurtbox3.fixed_position.x = anim_frame.get(Enums.StKey.Hurt3PosX, Hurtbox3.fixed_position.x)
		Hurtbox3.fixed_position.y = anim_frame.get(Enums.StKey.Hurt3PosY, Hurtbox3.fixed_position.y)
		
		Hitbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hit1ScaleX, Hitbox1.fixed_scale.x)
		Hitbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hit1ScaleY, Hitbox1.fixed_scale.y)
		Hitbox2.fixed_scale.x = anim_frame.get(Enums.StKey.Hit2ScaleX, Hitbox2.fixed_scale.x)
		Hitbox2.fixed_scale.y = anim_frame.get(Enums.StKey.Hit2ScaleY, Hitbox2.fixed_scale.y)
		
		Hurtbox1.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt1ScaleX, Hurtbox1.fixed_scale.x)
		Hurtbox1.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt1ScaleY, Hurtbox1.fixed_scale.y)
		Hurtbox2.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt2ScaleX, Hurtbox2.fixed_scale.x)
		Hurtbox2.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt2ScaleY, Hurtbox2.fixed_scale.y)
		Hurtbox3.fixed_scale.x = anim_frame.get(Enums.StKey.Hurt3ScaleX, Hurtbox3.fixed_scale.x)
		Hurtbox3.fixed_scale.y = anim_frame.get(Enums.StKey.Hurt3ScaleY, Hurtbox3.fixed_scale.y)
		
	attackData[Enums.StKey.attack_type] = anim_frame.get(Enums.StKey.attack_type, Enums.AttackType.Strike)
	attackData[Enums.StKey.attack_damage] = anim_frame.get(Enums.StKey.attack_damage, 50)
	attackData[Enums.StKey.guard] = anim_frame.get(Enums.StKey.guard, Enums.GuardType.Mid)
	attackData[Enums.StKey.hitstun] = anim_frame.get(Enums.StKey.hitstun, Util.DEFAULT_HITSTUN)
	attackData[Enums.StKey.blockstun] = anim_frame.get(Enums.StKey.blockstun, Util.DEFAULT_BLOCKSTUN)
	attackData[Enums.StKey.hitstop] = anim_frame.get(Enums.StKey.hitstop, Util.DEFAULT_HITSTOP)
	attackData[Enums.StKey.chip_damage] = anim_frame.get(Enums.StKey.chip_damage, 0)
	attackData[Enums.StKey.min_damage] = anim_frame.get(Enums.StKey.min_damage, 2)
	attackData[Enums.StKey.burst_OK] = anim_frame.get(Enums.StKey.burst_OK, true)
	attackData[Enums.StKey.meter_build] = anim_frame.get(Enums.StKey.meter_build, SGFixed.ONE*600)
	attackData[Enums.StKey.launch_dir_x] = anim_frame.get(Enums.StKey.launch_dir_x,  Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.launch_dir_y] = anim_frame.get(Enums.StKey.launch_dir_y,  Util.BASE_AIR_Y_PUSHBACK)
	attackData[Enums.StKey.block_dir_x] = anim_frame.get(Enums.StKey.block_dir_x,  Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.block_dir_y] = anim_frame.get(Enums.StKey.block_dir_y,  Util.BASE_AIR_Y_PUSHBACK)
	attackData[Enums.StKey.counter_hit] = anim_frame.get(Enums.StKey.counter_hit,  Enums.AttackType.Strike)
	attackData[Enums.StKey.counter_hitstun] = anim_frame.get(Enums.StKey.counter_hitstun, 0)
	attackData[Enums.StKey.counter_launch_dir_x] = anim_frame.get(Enums.StKey.counter_launch_dir_x, Util.BASE_STRIKE_X_PUSHBACK)
	attackData[Enums.StKey.counter_launch_dir_y] = anim_frame.get(Enums.StKey.counter_launch_dir_y, Util.BASE_AIR_Y_PUSHBACK)
	currentState[Enums.StKey.counterOK] = anim_frame.get(Enums.StKey.counterOK, false)

func tick() -> void:
	old_super_meter = currentState[Enums.StKey.super_meter]
	old_assist_meter = currentState[Enums.StKey.assist_meter]
	fighterState.update_rollback_state(currentState)
	var g_position = get_global_fixed_position()
	currentState["_pos_x"] = g_position.x
	currentState["_pos_y"] = g_position.y
	fighterState.state_transition()
	fighterState.handle_input(self.input_interpreter)
	fighterState.state_transition()
	hit_stop_tick()
	# frame number matters after this point
	fighterState.physics_tick()
	movement_physics_tick()
	hit_stun_update()
	anim_updates() # super flash needs to happen last

func hit_stop_tick() -> void:
	if (currentState.get(Enums.StKey.hitStopFrame, -1) > 0):
		currentState[Enums.StKey.hitStopFrame] -= 1
		if (currentState[Enums.StKey.frame] == -1):
			currentState[Enums.StKey.frame] = 0
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		currentState[Enums.StKey.frame] += 1
		for boxName in currentState[Enums.StKey.hit_cooldown]:
			#var out: String = ""
			if (currentState[Enums.StKey.hit_cooldown][boxName] >= 0):
				#out += str(currentState[Enums.StKey.hit_cooldown][boxName]) + " "
				currentState[Enums.StKey.hit_cooldown][boxName] -= 1
			#print(out)

func move_y() -> void:
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		self.velocity = SGFixed.vector2(
				0,
				currentState.get(Enums.StKey.velocity_y, 0)
			)
		move_and_slide()

func move_x() -> void:
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		var x_dir = 1
		if (currentState[Enums.StKey.leftface]):
			x_dir = -1
		self.velocity = SGFixed.vector2(
				x_dir * (currentState.get(Enums.StKey.velocity_x, 0) + currentState.get(Enums.StKey.modify_x, 0)),
				0
			)
		move_and_slide()

func movement_physics_tick() -> void:
	if (currentState[Enums.StKey.leftface]):
		self.fixed_scale.x = -1 * Util.fixed_abs(self.fixed_scale.x)
	else:
		self.fixed_scale.x = Util.fixed_abs(self.fixed_scale.x)
	
	if (currentState.get(Enums.StKey.hitStopFrame, -1) <= 0):
		currentState[Enums.StKey.velocity_x] = currentState.get(Enums.StKey.velocity_x, 0) + currentState.get(Enums.StKey.accel_x, 0)
		currentState[Enums.StKey.velocity_y] = currentState.get(Enums.StKey.velocity_y, 0) + currentState.get(Enums.StKey.accel_y, 0)
		
		cap_vel_x()
		cap_vel_y()
		
		if (currentState[Enums.StKey.velocity_x] <= 0):
			currentState[Enums.StKey.velocity_x] += Util.fixed_min(currentState.get(Enums.StKey.drag_x, 0), -currentState[Enums.StKey.velocity_x])
		else:
			currentState[Enums.StKey.velocity_x] -= Util.fixed_max(currentState.get(Enums.StKey.drag_x, 0), -currentState[Enums.StKey.velocity_x])
		if (currentState[Enums.StKey.modify_x] <= 0):
			currentState[Enums.StKey.modify_x] += Util.fixed_min(Util.MOD_FRICTION, -currentState[Enums.StKey.modify_x])
		else:
			currentState[Enums.StKey.modify_x] -= Util.fixed_max(Util.MOD_FRICTION, -currentState[Enums.StKey.modify_x])
	if (not assist_meter_build_frozen):
		currentState[Enums.StKey.assist_meter] = currentState.get(Enums.StKey.assist_meter, 0) + SGFixed.mul(currentState.get(Enums.StKey.sync_rate, 0), 45536)
		if (currentState[Enums.StKey.sync_rate] < Util.BASE_SYNC_RATE):
			currentState[Enums.StKey.sync_rate] -= SGFixed.mul(currentState[Enums.StKey.sync_rate]-Util.BASE_SYNC_RATE, 350)
		else:
			currentState[Enums.StKey.sync_rate] -= SGFixed.mul(currentState[Enums.StKey.sync_rate]-Util.BASE_SYNC_RATE, 150)
	if (currentState.get(Enums.StKey.assist_meter, 0) < 0):
		currentState[Enums.StKey.assist_meter] = 0
	elif (currentState.get(Enums.StKey.assist_meter, 0) >= Util.MAX_ASSIST_METER):
		currentState[Enums.StKey.assist_meter] = Util.MAX_ASSIST_METER

	if (currentState.get(Enums.StKey.super_meter, 0) < 0):
		currentState[Enums.StKey.super_meter] = 0
	elif (currentState.get(Enums.StKey.super_meter, 0) >= Util.MAX_SUPER_METER):
		currentState[Enums.StKey.super_meter] = Util.MAX_SUPER_METER
#	else:
#		currentState[Enums.StKey.super_meter] = Util.MAX_SUPER_METER

func cap_vel_x() -> void:
	if (currentState[Enums.StKey.velocity_x] <= -Util.MAX_VELOCITY_X):
		currentState[Enums.StKey.velocity_x] = -Util.MAX_VELOCITY_X
	elif (currentState[Enums.StKey.velocity_x] >= Util.MAX_VELOCITY_X):
		currentState[Enums.StKey.velocity_x] = Util.MAX_VELOCITY_X

func cap_vel_y() -> void:
	if (currentState[Enums.StKey.velocity_y] <= -Util.MAX_VELOCITY_Y):
		currentState[Enums.StKey.velocity_y] = -Util.MAX_VELOCITY_Y
	elif (currentState[Enums.StKey.velocity_y] >= Util.MAX_VELOCITY_Y):
		currentState[Enums.StKey.velocity_y] = Util.MAX_VELOCITY_Y

func on_ground() -> bool:
	return is_on_floor() and standing_on_ground()

func standing_on_ground() -> bool:
	return currentState["_pos_y"] >= Util.GROUND_HEIGHT

func on_wall() -> bool:
	return is_on_wall()# or on_corner()

func on_corner() -> bool:
	return Util.fixed_abs(fixed_position.x) >= Util.CORNER_POS

func standing_on_player() -> bool:
	return is_on_floor() and currentState["_pos_y"] < Util.GROUND_HEIGHT

func hit_stun_update() -> void:
	if (currentState.get(Enums.StKey.frame, -1) == 0 and currentState.get(Enums.StKey.hitCount, -1) == 0):
		emit_signal("combo_exit")

func setup(playerData:PlayerSetup):
	self.team = playerData.team
	currentState[Enums.StKey.leftface] = playerData.left_face
	var palette = Global.get_color_palette(not playerData.team, false)
	self.color_scheme = palette
	assert(palette != null)
	if (palette != null):
		$Sprite2D.material.set_shader_parameter("palette", palette)
	if (playerData.input_interpreter != null):
		self.input_interpreter = playerData.input_interpreter
	else:
		printerr("BasePlayer: NULL input interpreter")

func state_factory_setup(state_factory):
	if (fighterState == null):
		fighterState = PersistentState.new(
			currentState, state_factory, $NetworkAnimationPlayer)

func update_left_face(left_face):
	if (currentState[Enums.StKey.leftfaceOK]):
		if (currentState[Enums.StKey.leftface] != left_face):
			currentState[Enums.StKey.velocity_x] *= -1
		currentState[Enums.StKey.leftface] = left_face

func getAssistMeter() -> int:
	return currentState.get(Enums.StKey.assist_meter, 0)
func getSuperMeter() -> int:
	return currentState.get(Enums.StKey.super_meter, 0)
func getSyncRate() -> int:
	return currentState.get(Enums.StKey.sync_rate, 0)

func getFirstFrameCollide() -> Dictionary:
	return getFirstFrameCollideHelper(["Hitbox1", "Hitbox2"])

func getFirstFrameCollideHelper(hit_box_names) -> Dictionary:
	var firstFrameCollide = {}
	if (currentState[Enums.StKey.hit_box_colliding_frame] >= 0):
		for hitbox_name in hit_box_names:
			var hitbox = get_node(hitbox_name)
			# could be first frame collision
			for boxName in hitbox.firstFrameCollide.keys():
				if (not currentState[Enums.StKey.hit_cooldown].has(boxName)):
					firstFrameCollide[boxName] = 1
					currentState[Enums.StKey.hit_cooldown][boxName] = currentState[Enums.StKey.hit_box_colliding_frame]
				elif (currentState[Enums.StKey.hit_cooldown][boxName] <= -1):
					firstFrameCollide[boxName] = 1
					currentState[Enums.StKey.hit_cooldown][boxName] = currentState[Enums.StKey.hit_box_colliding_frame]
	return firstFrameCollide

func tick_box_collisions() -> void:
	for hitbox_name in ["Hitbox1", "Hitbox2"]:
		get_node(hitbox_name).process_collisions()
		#get_node(hitbox_name).update()

func normal_strike_hit(_attack_type: int, opponent_hit_data: Dictionary) -> void:
	if (opponent_hit_data["hitType"] == Enums.HitType.PushBlock):
		currentState[Enums.StKey.modify_x] = Util.FD_PUSHBACK
		currentState[Enums.StKey.super_meter] += Util.fixed_min(SGFixed.ONE * 400, attackData[Enums.StKey.meter_build])
	elif (opponent_hit_data["hitType"] == Enums.HitType.JustPushBlock):
		currentState[Enums.StKey.modify_x] = Util.IBFD_PUSHBACK
		currentState[Enums.StKey.super_meter] += Util.fixed_min(SGFixed.ONE * 400, attackData[Enums.StKey.meter_build])
	elif (opponent_hit_data["hitType"] == Enums.HitType.Block):
		currentState[Enums.StKey.super_meter] += Util.fixed_min(SGFixed.ONE * 400, attackData[Enums.StKey.meter_build])
	elif (opponent_hit_data["hitType"] == Enums.HitType.Parry):
		pass # no meter gain
	else:
		currentState[Enums.StKey.super_meter] += attackData[Enums.StKey.meter_build]
	currentState[Enums.StKey.modify_x] = Util.fixed_min(currentState[Enums.StKey.modify_x], fighterState.state.combo_pushback(opponent_hit_data[Enums.StKey.comboTime]))
	if (opponent_hit_data["in_corner"] and standing_on_ground() and opponent_hit_data["hitType"] != Enums.HitType.Parry):
		currentState[Enums.StKey.modify_x] = Util.fixed_min(currentState[Enums.StKey.modify_x], Util.CORNER_PUSHBACK)

func on_attack_hit(attack_type: int, opponent_hit_data: Dictionary) -> void:
	if (opponent_hit_data["counter"]):
		currentState[Enums.StKey.super_meter] += SGFixed.ONE * 1000
		currentState[Enums.StKey.sync_rate] += SGFixed.ONE * 20
	if (opponent_hit_data["otg"]):
		currentState[Enums.StKey.sync_rate] += SGFixed.ONE * 20
	if (currentState[Enums.StKey.hitStopFrame] < attackData[Enums.StKey.hitstop]):
		if (currentState[Enums.StKey.hitStopFrame] <= 0):
			currentState[Enums.StKey.hitStopFrame] = attackData[Enums.StKey.hitstop]
	match attack_type:
		Enums.AttackType.Strike:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if(opponent_hit_data[Enums.StKey.comboTime] < 1):
					currentState[Enums.StKey.sync_rate] += Util.FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			elif (opponent_hit_data["hitType"] == Enums.HitType.Block):
				currentState[Enums.StKey.sync_rate] += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.Launcher:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					currentState[Enums.StKey.sync_rate] += Util.FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				currentState[Enums.StKey.sync_rate] += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.GroundBouncer:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					currentState[Enums.StKey.sync_rate] += Util.FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				currentState[Enums.StKey.sync_rate] += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.WallBouncer:
			if (opponent_hit_data["hitType"] == Enums.HitType.Strike):
				if (opponent_hit_data[Enums.StKey.comboTime] < 1):
					currentState[Enums.StKey.sync_rate] += Util.FIRST_HIT_SYNC_BOOST
				fighterState.reaction(Enums.Reaction.StrikeHit, input_interpreter)
			if (opponent_hit_data["hitType"] == Enums.HitType.Block):
				currentState[Enums.StKey.sync_rate] += SGFixed.ONE*3
			normal_strike_hit(attack_type, opponent_hit_data)
			$NetworkAnimationPlayer.speed_scale = 0
		Enums.AttackType.Throw:
			if (opponent_hit_data["hitType"] == Enums.HitType.Throw):
				fighterState.reaction(Enums.Reaction.ThrowHit, input_interpreter)
		Enums.AttackType.AirThrow:
			if (opponent_hit_data["hitType"] == Enums.HitType.Throw):
				fighterState.reaction(Enums.Reaction.ThrowHit, input_interpreter)
		Enums.AttackType.BurstLock:
			pass
	if (opponent_hit_data["hitType"] == Enums.HitType.Parry):
		currentState[Enums.StKey.hitStopFrame] = Util.PARRY_HIT_STOP + Util.PARRY_ATTACKER_EXTRA_HIT_STOP

func damage_scale(opponent_attack) -> int:
	return Util.damage_scaling(
		opponent_attack[Enums.StKey.attack_damage],
		opponent_attack[Enums.StKey.min_damage],
		currentState[Enums.StKey.hitCount])

func normal_strike_hurt(_react_type: int, opponent_attack: Dictionary, leftface: bool, old_hit_stun: int, hit_data: Dictionary) -> void:
	var scaled = damage_scale(opponent_attack)
	var g_position = get_global_fixed_position()
	SyncManager.spawn("HitVFX", get_parent(), Global.HitVFX,
	{
		position_x = g_position.x,
		position_y = g_position.y - Util.HIT_EFFECT_Y_OFFSET,
		leftface = currentState[Enums.StKey.leftface],
	})
	currentState[Enums.StKey.super_meter] += SGFixed.ONE * 400
	currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop]
	hit_data["otg"] = has_property(Enums.StateProperty.OTG)
	emit_signal("strike_hurt", scaled, currentState[Enums.StKey.hitCount], old_hit_stun < 0, false, opponent_attack[Enums.StKey.guard])

# beware! hit_data output variable
func normal_strike_block(opponent_attack: Dictionary, hit_data: Dictionary) -> void:
	currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.blockstun]
	currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop]
	if (currentState[Enums.StKey.super_meter] > 0 and input_interpreter.is_push_blocking()):
		SyncManager.play_sound("pushblock1", Global.PushBlockSound, {"bus": "Sound"})
		var g_position = get_global_fixed_position()
		SyncManager.spawn("PushBlockVFX", get_parent(), Global.PushBlockVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
		currentState[Enums.StKey.super_meter] -= SGFixed.ONE * 800
		currentState[Enums.StKey.hitstun] += Util.FD_EXTRA_BLOCKSTUN
		if (fighterState.has_property(Enums.StateProperty.ExtraChip)):
			currentState[Enums.StKey.super_meter] -= SGFixed.ONE * 400
		fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
		hit_data["hitType"] = Enums.HitType.PushBlock
		emit_signal("strike_hurt", 0, currentState[Enums.StKey.hitCount], false, true, opponent_attack[Enums.StKey.guard])
	else:
		SyncManager.play_sound("block1", Global.BlockLV3Sound, {"bus": "Sound"})
		var g_position = get_global_fixed_position()
		SyncManager.spawn("BlockVFX", get_parent(), Global.BlockVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
		currentState[Enums.StKey.super_meter] += SGFixed.ONE * 200
		fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
		hit_data["hitType"] = Enums.HitType.Block
		var chip_damage = opponent_attack[Enums.StKey.chip_damage]
		var attack_damage = opponent_attack[Enums.StKey.attack_damage]
		if (fighterState.has_property(Enums.StateProperty.ExtraChip)):
			chip_damage += 10
			currentState[Enums.StKey.assist_meter] -= SGFixed.ONE*800
		if (currentState[Enums.StKey.assist_meter] < Util.ASSIST_STOCK):
			chip_damage += 4
		currentState[Enums.StKey.assist_meter] -= SGFixed.ONE*10*(attack_damage+80)
		currentState[Enums.StKey.sync_rate] -= 5536*(attack_damage+10)
		emit_signal("strike_hurt", chip_damage, currentState[Enums.StKey.hitCount], false, true, opponent_attack[Enums.StKey.guard])

func strike_parry(_opponent_attack: Dictionary, hit_data: Dictionary) -> void:
	SyncManager.play_sound("parry", Global.ParrySound, {"bus": "Sound"})
	var g_position = get_global_fixed_position()
	if (fighterState.has_property(Enums.StateProperty.RedParry)):
		SyncManager.spawn("RedParryVFX", get_parent(), Global.RedParryVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
	else:
		SyncManager.spawn("ParryVFX", get_parent(), Global.ParryVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
	currentState[Enums.StKey.sync_rate] += Util.PARRY_SYNC_RATE_BOOST
	currentState[Enums.StKey.super_meter] += Util.PARRY_SUPER_METER_BOOST
	hit_data["hitType"] = Enums.HitType.Parry
	currentState[Enums.StKey.hitStopFrame] = Util.PARRY_HIT_STOP

func just_strike_block(opponent_attack: Dictionary, hit_data: Dictionary) -> void:
	currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.blockstun]
	currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop]
	if (currentState[Enums.StKey.super_meter] > 0 and input_interpreter.is_push_blocking()):
		SyncManager.play_sound("pushblock1", Global.PushBlockSound, {"bus": "Sound"})
		SyncManager.play_sound("just", Global.JustBlockSound, {"bus": "Sound"})
		var g_position = get_global_fixed_position()
		SyncManager.spawn("JustPushBlockVFX", get_parent(), Global.JustPushBlockVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
		currentState[Enums.StKey.super_meter] -= SGFixed.ONE * 2500
		currentState[Enums.StKey.hitstun] += Util.IBFD_EXTRA_BLOCKSTUN
		if (fighterState.has_property(Enums.StateProperty.ExtraChip)):
			currentState[Enums.StKey.super_meter] -= SGFixed.ONE * 1000
		fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
		hit_data["hitType"] = Enums.HitType.JustPushBlock
		emit_signal("strike_hurt", 0, currentState[Enums.StKey.hitCount], false, true, opponent_attack[Enums.StKey.guard])
	else:
		SyncManager.play_sound("block1", Global.BlockLV3Sound, {"bus": "Sound"})
		SyncManager.play_sound("just", Global.JustBlockSound, {"bus": "Sound"})
		var g_position = get_global_fixed_position()
		SyncManager.spawn("JustBlockVFX", get_parent(), Global.JustBlockVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
		currentState[Enums.StKey.super_meter] += SGFixed.ONE * 400
		fighterState.reaction(Enums.Reaction.JustBlockHurt, input_interpreter)
		hit_data["hitType"] = Enums.HitType.Block
		var chip_damage = opponent_attack[Enums.StKey.chip_damage]
		var attack_damage = opponent_attack[Enums.StKey.attack_damage]
		if (fighterState.has_property(Enums.StateProperty.ExtraChip)):
			chip_damage += 10
			currentState[Enums.StKey.assist_meter] -= SGFixed.ONE*800
		if (currentState[Enums.StKey.assist_meter] < Util.ASSIST_STOCK):
			chip_damage += 4
		currentState[Enums.StKey.assist_meter] -= SGFixed.ONE*7*(attack_damage+80)
#		currentState[Enums.StKey.sync_rate] -= 5536*(attack_damage+10)
		emit_signal("strike_hurt", chip_damage, currentState[Enums.StKey.hitCount], false, true, opponent_attack[Enums.StKey.guard])

func on_attack_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hitbox_name: String = "Unknown") -> Dictionary:
	var hit_data : Dictionary = {
		Enums.StKey.hitCount: currentState[Enums.StKey.hitCount],
		Enums.StKey.comboTime: currentState[Enums.StKey.comboTime],
		"hitType": Enums.HitType.Strike,
		"in_corner": on_corner(),
		"counter": false,
		"otg": false,
	}
	emit_signal("attack_hurt", hitbox_name)
	if (opponent_attack[Enums.StKey.counter_hit] != Enums.AttackType.BurstLock and
		(currentState[Enums.StKey.counterOK] || (not on_block(opponent_attack, leftface) and currentState[Enums.StKey.assist_meter] < Util.ASSIST_STOCK ))):
		if (currentState[Enums.StKey.assist_meter] < Util.ASSIST_STOCK):
#			currentState[Enums.StKey.sync_rate] += SGFixed.ONE*5
			currentState[Enums.StKey.assist_meter] += SGFixed.ONE*2000
#			opponent_attack[Enums.StKey.attack_damage] += 5
		var g_position = get_global_fixed_position()
		match opponent_attack[Enums.StKey.counter_hit]:
			Enums.AttackType.Strike:
				currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.counter_launch_dir_x]
				currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.counter_launch_dir_y]
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				currentState[Enums.StKey.hitCount] += 1
				currentState[Enums.StKey.leftface] = not attack_leftface
				currentState[Enums.StKey.leftfaceOK] = false
				currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
				var old_hit_stun: int = currentState[Enums.StKey.hitstun]
				if (on_parry(opponent_attack, leftface)):
					fighterState.reaction(Enums.Reaction.ParryHurt, input_interpreter)
					strike_parry(opponent_attack, hit_data)
				else:
					SyncManager.spawn("CHHitVFX", get_parent(), Global.CHHitVFX,
					{
						position_x = g_position.x,
						position_y = g_position.y,
						leftface = currentState[Enums.StKey.leftface],
					})
					hit_data["counter"] = true
					fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
					normal_strike_hurt(react_type, opponent_attack, leftface, old_hit_stun, hit_data)
					currentState[Enums.StKey.hitStopFrame] += 10
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun] + opponent_attack[Enums.StKey.counter_hitstun]
					SyncManager.play_sound("counterhit", Global.CHHitSound, {"bus": "Sound"})
			Enums.AttackType.Launcher:
				counter_launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.AttackType.GroundBouncer:
				currentState[Enums.StKey.ground_bounce] += 1
				counter_launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.AttackType.WallBouncer:
				currentState[Enums.StKey.wall_bounce] += 1
				counter_launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.AttackType.AirThrow:
				if (has_property(Enums.StateProperty.AirThrowOK)):
					SyncManager.spawn("CHHitVFX", get_parent(), Global.CHHitVFX,
					{
						position_x = g_position.x,
						position_y = g_position.y,
						leftface = currentState[Enums.StKey.leftface],
					})
					hit_data["counter"] = true
					fighterState.reaction(Enums.Reaction.ThrowHurt, input_interpreter)
					hit_data["hitType"] = Enums.HitType.Throw
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
					currentState[Enums.StKey.leftface] = not attack_leftface
					currentState[Enums.StKey.leftfaceOK] = false
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
					currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
					currentState[Enums.StKey.hitStopFrame] += 10
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun] + opponent_attack[Enums.StKey.counter_hitstun]
					SyncManager.play_sound("counterhit", Global.CHHitSound, {"bus": "Sound"})
				else:
					hit_data["hitType"] = Enums.HitType.Block
			Enums.AttackType.Throw:
				if (has_property(Enums.StateProperty.GroundThrowOK)):
					SyncManager.spawn("CHHitVFX", get_parent(), Global.CHHitVFX,
					{
						position_x = g_position.x,
						position_y = g_position.y,
						leftface = currentState[Enums.StKey.leftface],
					})
					hit_data["counter"] = true
					fighterState.reaction(Enums.Reaction.ThrowHurt, input_interpreter)
					hit_data["hitType"] = Enums.HitType.Throw
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
					currentState[Enums.StKey.leftface] = not attack_leftface
					currentState[Enums.StKey.leftfaceOK] = false
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
					currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
					currentState[Enums.StKey.hitStopFrame] += 10
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun] + opponent_attack[Enums.StKey.counter_hitstun]
					SyncManager.play_sound("counterhit", Global.CHHitSound, {"bus": "Sound"})
				else:
					hit_data["hitType"] = Enums.HitType.Block
			Enums.AttackType.BurstLock:
				fighterState.reaction(Enums.Reaction.BurstLockHurt, input_interpreter)
	else:
		match react_type:
			Enums.Reaction.StrikeHurt:
				currentState[Enums.StKey.hitCount] += 1
				currentState[Enums.StKey.leftface] = not attack_leftface
				currentState[Enums.StKey.leftfaceOK] = false
				currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				var old_hit_stun: int = currentState[Enums.StKey.hitstun]
				currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
				if (on_block(opponent_attack, leftface)):
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.block_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.block_dir_y]
					if (input_interpreter.is_just_blocking(leftface)):
						just_strike_block(opponent_attack, hit_data)
					else:
						normal_strike_block(opponent_attack, hit_data)
				else:
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
					play_hit_lvl1_sound()
					fighterState.reaction(Enums.Reaction.StrikeHurt, input_interpreter)
					normal_strike_hurt(react_type, opponent_attack, leftface, old_hit_stun, hit_data)
			Enums.Reaction.LaunchHurt:
				launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.Reaction.GroundBounceHurt:
				if (not on_block(opponent_attack, leftface)):
					currentState[Enums.StKey.ground_bounce] += 1
				launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.Reaction.WallBounceHurt:
				if (not on_block(opponent_attack, leftface)):
					currentState[Enums.StKey.wall_bounce] += 1
				launcher_hurt(react_type, opponent_attack, leftface, attack_leftface, hit_data)
			Enums.Reaction.ThrowHurt:
				if (has_property(Enums.StateProperty.GroundThrowOK)):
					fighterState.reaction(Enums.Reaction.ThrowHurt, input_interpreter)
					hit_data["hitType"] = Enums.HitType.Throw
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
					currentState[Enums.StKey.leftface] = not attack_leftface
					currentState[Enums.StKey.leftfaceOK] = false
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
					currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				else:
					hit_data["hitType"] = Enums.HitType.Block
			Enums.Reaction.AirThrowHurt:
				if (has_property(Enums.StateProperty.AirThrowOK)):
					fighterState.reaction(Enums.Reaction.ThrowHurt, input_interpreter)
					hit_data["hitType"] = Enums.HitType.Throw
					currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
					currentState[Enums.StKey.leftface] = not attack_leftface
					currentState[Enums.StKey.leftfaceOK] = false
					currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
					currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
					currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
				else:
					hit_data["hitType"] = Enums.HitType.Block
			Enums.Reaction.BurstLockHurt:
				fighterState.reaction(Enums.Reaction.BurstLockHurt, input_interpreter)
	return hit_data

func launcher_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hit_data):
	currentState[Enums.StKey.hitCount] += 1
	currentState[Enums.StKey.leftface] = not attack_leftface
	currentState[Enums.StKey.leftfaceOK] = false
	currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
	var old_hit_stun: int = currentState[Enums.StKey.hitstun]
	currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
	if (on_block(opponent_attack, leftface)):
		currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.block_dir_x]
		currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.block_dir_y]
		if (input_interpreter.is_just_blocking(leftface)):
			just_strike_block(opponent_attack, hit_data)
		else:
			normal_strike_block(opponent_attack, hit_data)
	else:
		currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.launch_dir_x]
		currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.launch_dir_y]
		play_hit_lvl3_sound()
		fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
		normal_strike_hurt(react_type, opponent_attack, leftface, old_hit_stun, hit_data)

func counter_launcher_hurt(react_type: int, opponent_attack: Dictionary, leftface: bool, attack_leftface: bool, hit_data):
	var g_position = get_global_fixed_position()
	currentState[Enums.StKey.velocity_x] = opponent_attack[Enums.StKey.counter_launch_dir_x]
	currentState[Enums.StKey.velocity_y] = opponent_attack[Enums.StKey.counter_launch_dir_y]
	currentState[Enums.StKey.burst_OK] = opponent_attack[Enums.StKey.burst_OK]
	currentState[Enums.StKey.hitCount] += 1
	currentState[Enums.StKey.leftface] = not attack_leftface
	currentState[Enums.StKey.leftfaceOK] = false
	var old_hit_stun: int = currentState[Enums.StKey.hitstun]
	currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun]
	if (on_parry(opponent_attack, leftface)):
		fighterState.reaction(Enums.Reaction.ParryHurt, input_interpreter)
		strike_parry(opponent_attack, hit_data)
	else:
		SyncManager.spawn("CHHitVFX", get_parent(), Global.CHHitVFX,
		{
			position_x = g_position.x,
			position_y = g_position.y,
			leftface = currentState[Enums.StKey.leftface],
		})
		hit_data["counter"] = true
		fighterState.reaction(Enums.Reaction.LaunchHurt, input_interpreter)
		normal_strike_hurt(react_type, opponent_attack, leftface, old_hit_stun, hit_data)
		currentState[Enums.StKey.hitStopFrame] = opponent_attack[Enums.StKey.hitstop] + 10
		currentState[Enums.StKey.hitstun] = opponent_attack[Enums.StKey.hitstun] + opponent_attack[Enums.StKey.counter_hitstun]
		SyncManager.play_sound("counterhit", Global.CHHitSound, {"bus": "Sound"})


func on_parry(opponent_attack: Dictionary, _leftface: bool) -> bool:
	var parry_ok = false
	if (has_property(Enums.StateProperty.HighParry)):
		match opponent_attack[Enums.StKey.guard]:
			Enums.GuardType.Mid:
				parry_ok = true
			Enums.GuardType.High:
				parry_ok = true
			Enums.GuardType.Low:
				pass
	if (has_property(Enums.StateProperty.LowParry)):
		match opponent_attack[Enums.StKey.guard]:
			Enums.GuardType.Mid:
				pass
			Enums.GuardType.High:
				pass
			Enums.GuardType.Low:
				parry_ok = true
	return parry_ok

func on_block(opponent_attack: Dictionary, leftface: bool) -> bool:
	if (has_property(Enums.StateProperty.BlockingOK) and
		(has_property(Enums.StateProperty.CrossupProtect) or input_interpreter.is_blocking(leftface))):
		match opponent_attack[Enums.StKey.guard]:
			Enums.GuardType.Mid:
				fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
				return true
			Enums.GuardType.High:
				if (has_property(Enums.StateProperty.HighProtect) or not input_interpreter.is_low_blocking(leftface)):
					fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
					return true
			Enums.GuardType.Low:
				if (has_property(Enums.StateProperty.LowProtect) or input_interpreter.is_low_blocking(leftface)):
					fighterState.reaction(Enums.Reaction.BlockHurt, input_interpreter)
					return true
	return false

func update_opponent_anchor(opponent: BasePlayer) -> void:
	pass

func ko() -> void:
	fighterState.reaction(Enums.Reaction.KOHurt, input_interpreter)
	fighterState.state_transition()

func remove_cancel_option() -> void:
	currentState[Enums.StKey.cancelState] = ""

func skip_intro() -> void:
	fighterState.change_state("Stand")
	fighterState.state_transition()

func start_glowing():
	_shader_mat.set_shader_parameter("mode", 1)

func stop_glowing():
	_shader_mat.set_shader_parameter("mode", 0)

func freeze_player_sim() -> void:
	$NetworkAnimationPlayer.speed_scale = 0

func un_freeze_player_sim() -> void:
	$NetworkAnimationPlayer.speed_scale = 1

func ground_land() -> void:
	fighterState.reaction(Enums.Reaction.GroundLand, input_interpreter)

func wall_land() -> void:
	fighterState.reaction(Enums.Reaction.WallLand, input_interpreter)

func has_property(property: int) -> bool:
	return fighterState.has_property(property)

func play_hit_lvl1_sound() -> void:
	SyncManager.play_sound("hit1", Global.HitLV1Sound, {"bus": "Sound"})

func play_hit_lvl3_sound() -> void:
	SyncManager.play_sound("hit3", Global.HitLV3Sound, {"bus": "Sound"})
