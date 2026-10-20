extends "res://game/state/kanata/mainstates/kanataAttackState.gd"

class_name KanataSuperFiftyKGWhiffState

func _init():
	endFrame = 60
	
	anim_data = {
		0 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -655360, Enums.StKey.Hurt1PosY : -23855102,
			Enums.StKey.Hurt1ScaleX : 497627, Enums.StKey.Hurt1ScaleY : 523538,
			Enums.StKey.Hurt2PosX : 3211265, Enums.StKey.Hurt2PosY : -15269887,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : 65, Enums.StKey.Hurt3PosY : -10485760,
			Enums.StKey.Hurt3ScaleX : 871288, Enums.StKey.Hurt3ScaleY : 1034829,
			},
		1 : {
			Enums.StKey.Summon : "superFlash",
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : false,
			Enums.StKey.Hurt1Disable : true,Enums.StKey.Hurt2Disable : true,Enums.StKey.Hurt3Disable : true,
			Enums.StKey.Hurt1PosX : -655360, Enums.StKey.Hurt1PosY : -23855102,
			Enums.StKey.Hurt1ScaleX : 497627, Enums.StKey.Hurt1ScaleY : 523538,
			Enums.StKey.Hurt2PosX : 3211265, Enums.StKey.Hurt2PosY : -15269887,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : 65, Enums.StKey.Hurt3PosY : -10485760,
			Enums.StKey.Hurt3ScaleX : 871288, Enums.StKey.Hurt3ScaleY : 1034829,
			Enums.StKey.hit_box_colliding_frame : 254, 
			Enums.StKey.Hit1PosX : 6160384, Enums.StKey.Hit1PosY : -8192000,
			Enums.StKey.Hit1ScaleX : 1526897, Enums.StKey.Hit1ScaleY : 793983,
			Enums.StKey.attack_type : Enums.AttackType.Throw,
			Enums.StKey.counter_hit: Enums.AttackType.Throw,
			Enums.StKey.burst_OK: false,
			Enums.StKey.launch_dir_x : 0,
			Enums.StKey.launch_dir_y : 0,
			Enums.StKey.counter_launch_dir_x: 0,
			Enums.StKey.counter_launch_dir_y: 0,
			Enums.StKey.hitstun : 300,
			Enums.StKey.hitstop: 1,
			},
		2 : {
			Enums.StKey.counterOK : true,
			Enums.StKey.Hit1Disable : true,
			Enums.StKey.Hit2Disable : true,
			Enums.StKey.Hurt1Disable : false,Enums.StKey.Hurt2Disable : false,Enums.StKey.Hurt3Disable : false,
			Enums.StKey.Hurt1PosX : -655360, Enums.StKey.Hurt1PosY : -23855102,
			Enums.StKey.Hurt1ScaleX : 497627, Enums.StKey.Hurt1ScaleY : 523538,
			Enums.StKey.Hurt2PosX : 3211265, Enums.StKey.Hurt2PosY : -15269887,
			Enums.StKey.Hurt2ScaleX : 964115, Enums.StKey.Hurt2ScaleY : 370909,
			Enums.StKey.Hurt3PosX : 65, Enums.StKey.Hurt3PosY : -10485760,
			Enums.StKey.Hurt3ScaleX : 871288, Enums.StKey.Hurt3ScaleY : 1034829,
			},
	}
# Writing _delta instead of delta here prevents the unused variable warning.
func enter(state: Dictionary) -> void:
	super.enter(state)
	state[Enums.StKey.drag_x] = Util.SLIPPERY_FRICTION
	state[Enums.StKey.super_meter] -= Util.LEVEL_THREE_SUPER
	anim.play("KanataFiftyWhiff")

func jump_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func special_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass

func gatling_cancel(state: Dictionary, interpreter: InputInterpreter):
	pass
	
func meter_cancel(state: Dictionary, interpreter: InputInterpreter):
	if (boost_OK(state, interpreter)):
		change_state.call("BoostCancel")

func reaction(state: Dictionary, interpreter: InputInterpreter,event_cause: int) -> void:
	super.reaction(state, interpreter, event_cause)
	if (event_cause == Enums.Reaction.ThrowHit):
		change_state.call("KanataSuperFiftyKGHit")


func has_property(state: Dictionary,property: int) -> bool:
	match property:
		Enums.StateProperty.GroundThrowOK:
			return state[Enums.StKey.frame] > 7
		Enums.StateProperty.BlockingOK:
			return false
		_:
			return super.has_property(state,property)
