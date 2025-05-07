func queue_resource(path, p_in_front = false):
	ResourceLoader.load_threaded_request(path)

func get_resource(path):
	return ResourceLoader.load_threaded_get(path)

func start():
	pass

func get_stage_background():
	return Global.LOADED_STAGE_BACKGROUND
	
func load_stage_art():
	var stage_art: Node
	var id: int
	id = Global.STAGE_ART_ID
	if (Global.STAGE_ART_ID == 0):
		id = char_id_to_stage(Global.STAGE_CHARACTER())
	elif (Global.STAGE_ART_ID == 1):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		id = rng.randi_range(3, len(Global.STAGE_LIST)-2)
		Global.STAGE_ART_ID = id
	elif (Global.STAGE_ART_ID == 2):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		id = rng.randi_range(3, len(Global.STAGE_LIST)-2)
	stage_art = id_to_stage(id)
	Global.LOADED_STAGE_BACKGROUND = stage_art

func char_id_to_stage(char_id: int) -> int:
	var out_id = Global.STAGE_LIST.find("Ruined HoloGra Office")
	match char_id:
		Enums.PointCharacters.Subaru:
			out_id = Global.STAGE_LIST.find("Pleiades Star Beach")
		Enums.PointCharacters.Oga:
			out_id = Global.STAGE_LIST.find("Streets!")
		Enums.PointCharacters.Kanata:
			out_id = Global.STAGE_LIST.find("Hollow Garden")
	return out_id

func id_to_stage(id: int) -> Node:
	var stage_art: Node
	if (id == Global.STAGE_LIST.find("Auto")):
		stage_art = load("res://game/assets/backgroundStages/RuinedHoloGraOffice.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Random Once")):
		pass # random one
	elif (id == Global.STAGE_LIST.find("Random All")):
		pass # random all
	elif (id == Global.STAGE_LIST.find("Ruined HoloGra Office")):
		stage_art = load("res://game/assets/backgroundStages/RuinedHoloGraOffice.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Pleiades Star Beach")):
		stage_art = load("res://game/assets/backgroundStages/PleiadesStarBeach.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Hollow Garden")):
		stage_art = load("res://game/assets/backgroundStages/HollowGarden.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Heart Of The Forest")):
		stage_art = load("res://game/assets/backgroundStages/HeartOfTheForest.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("News Room")):
		stage_art = load("res://game/assets/backgroundStages/NewsRoom.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Streets!")):
		stage_art = load("res://game/assets/backgroundStages/Streets.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("Waffle House")):
		stage_art = load("res://game/assets/backgroundStages/WaffleHouse.tscn").instantiate()
	elif (id == Global.STAGE_LIST.find("None")):
		stage_art = load("res://game/assets/backgroundStages/Empty.tscn").instantiate()
	else:
		stage_art = load("res://game/assets/backgroundStages/RuinedHoloGraOffice.tscn").instantiate()
		print("OOB STAGE_ART_ID " + str(id))
	return stage_art
