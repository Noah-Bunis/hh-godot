extends RefCounted

const ReplayLogger = preload("res://game/menus/replay/ReplayLogger.gd")
var replay_logger

func create_dir(dir_name):
	var dir = DirAccess.open(dir_name)
	if not dir.dir_exists(dir_name):
		dir.make_dir(dir_name)
	return dir

func get_match_info() -> Dictionary:
	var match_info: Dictionary = {
			"point_1" : Global.PLAYER_1_CHARACTER[0],
			"point_node_1" : Global.PLAYER_1_NODE_PATH[0],
			"point_2" : Global.PLAYER_2_CHARACTER[0],
			"point_node_2" : Global.PLAYER_2_NODE_PATH[0],
			"assist_1" : Global.PLAYER_1_CHARACTER[1],
			"assist_node_1" : Global.PLAYER_1_NODE_PATH[1],
			"assist_2" : Global.PLAYER_2_CHARACTER[1],
			"assist_node_2" : Global.PLAYER_2_NODE_PATH[1],
			"point_1_color" : Global.PLAYER_1_COLOR[0],
			"assist_1_color" : Global.PLAYER_1_COLOR[1],
			"point_2_color" : Global.PLAYER_2_COLOR[0],
			"assist_2_color" : Global.PLAYER_2_COLOR[1],
		}
	return match_info

func create_log(LOG_FILE_DIRECTORY, REPLAY_LOG_FILE_DIRECTORY, game_mode_root) -> bool:
	var match_info = get_match_info()
	var dir = create_dir(LOG_FILE_DIRECTORY)
	
	var datetime = Time.get_datetime_dict_from_system(true)
	var matchup_name = get_match_up_name(
			Global.PLAYER_1_CHARACTER[0],
			Global.PLAYER_1_CHARACTER[1],
			Global.PLAYER_2_CHARACTER[0],
			Global.PLAYER_2_CHARACTER[1])
	var log_file_name = "%04d%02d%02d-%02d%02d%02d-peer-%d" % [
		datetime['year'],
		datetime['month'],
		datetime['day'],
		datetime['hour'],
		datetime['minute'],
		datetime['second'],
		SyncManager.network_adaptor.get_unique_id(),
	]
	log_file_name = log_file_name+matchup_name+".log"
	SyncManager.start_logging(LOG_FILE_DIRECTORY + '/' + log_file_name, match_info)

	var replay_dir = create_dir(REPLAY_LOG_FILE_DIRECTORY)
	
	log_file_name = "%04d%02d%02d-%02d%02d%02d" % [
		datetime['year'],
		datetime['month'],
		datetime['day'],
		datetime['hour'],
		datetime['minute'],
		datetime['second'],
	]
	log_file_name = log_file_name+matchup_name+".log"
	replay_logger = ReplayLogger.new(SyncManager, game_mode_root)
	if replay_logger.start(REPLAY_LOG_FILE_DIRECTORY + '/' + log_file_name, match_info) != OK:
		print("Failed to start replay logger")
		replay_logger.stop()
		return false
	return true

func stop() -> void:
	replay_logger.stop()

func point_name_abbrev(point) -> String:
	match point:
		Enums.PointCharacters.Subaru:
			return "SUB"
		Enums.PointCharacters.Mio:
			return "MIO"
		Enums.PointCharacters.Oga:
			return "OGA"
		Enums.PointCharacters.Ollie:
			return "OLL"
		Enums.PointCharacters.Kanata:
			return "KAN"
		Enums.PointCharacters.Suisei:
			return "SUI"
		Enums.PointCharacters.Flayon: 
			return "FLA"
		Enums.PointCharacters.Kurokami:
			return "KUR"
		_:
			printerr("invalid point character given")
			return "???"

func assist_name_abbrev(assist) -> String:
	match assist:
		Enums.AssistCharacters.Fubuki:
			return "FUB"
		Enums.AssistCharacters.Sora:
			return "SOR"
		Enums.AssistCharacters.OkaKoro:
			return "OKO"
		Enums.AssistCharacters.Sana:
			return "SNA"
		Enums.AssistCharacters.Hakka:
			return "HAK"
		Enums.AssistCharacters.Subaru:
			return "SUB"
		Enums.AssistCharacters.Mio:
			return "MIO"
		Enums.AssistCharacters.Oga: 
			return "OGA"
		Enums.AssistCharacters.Ollie: 
			return "OLL"
		Enums.AssistCharacters.Kanata: 
			return "KAN"
		Enums.AssistCharacters.Suisei: 
			return "SUI"
		Enums.AssistCharacters.Flayon: 
			return "FLA"
		_:
			printerr("invalid assist character given")
			return "???"

func get_match_up_name(point1, assist1, point2, assist2) -> String:
	return point_name_abbrev(point1) + assist_name_abbrev(assist1) + "v" + point_name_abbrev(point2) + assist_name_abbrev(assist2)
