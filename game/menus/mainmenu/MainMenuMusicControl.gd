extends Node2D

@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer
@onready var menu_sounds : AudioStreamPlayer = $MenuSounds

var current_song: String = ""

var rng = RandomNumberGenerator.new()

var menu_music
var character_select_music
var angel_comeback_music
var angel_music
var angel_training_music

var MoveSound
var SelectSound
var DeselectSound

var seek_point: float = 0.0

var fade_out: Tween
var fade_in: Tween

func _ready():
	menu_music = load("res://game/assets/music/WIM.ogg")
	character_select_music = load("res://game/assets/music/Heroine Audition.ogg")
	angel_comeback_music = load("res://game/assets/music/Go Go Angel Subaru.ogg")
	angel_music = load("res://game/assets/music/SummerAngelWingsShort.ogg")
	angel_training_music = load("res://game/assets/music/Summer Angel Wings.ogg")

	MoveSound = load("res://game/assets/sfx/CursorMove.wav")
	SelectSound = load("res://game/assets/sfx/CursorSelect.wav")
	DeselectSound = load("res://game/assets/sfx/CursorDeselect.wav")
	
	rng.randomize()
	reset_seek()
	audio_player.bus = "Music"
	audio_player.connect("finished", Callable(self, "music_finished"))
	menu_sounds.bus = "Sound"

func play_cursor_move():
	menu_sounds.set_stream(MoveSound)
	menu_sounds.play()

func play_cursor_select():
	menu_sounds.set_stream(SelectSound)
	menu_sounds.play()

func play_cursor_deselect():
	menu_sounds.set_stream(DeselectSound)
	menu_sounds.play()

func music_finished():
	seek_point = 0
	if (current_song == "MainMenu"):
		current_song = ""
		play_main_menu_music()
	elif (current_song == "TitleScreen"):
		current_song = ""
		play_title_screen_music()
	elif (current_song == "CharacterSelect"):
		play_character_select_music()
	elif (current_song == "WinSpiralTones"):
		pass
	else:
		start_music()
		
func stop_fade_out():
	pass
	#if (is_instance_valid(fade_out)):
		#remove_child(fade_out)
		#fade_out.free()

func stop_fade_in():
	pass
	#if (is_instance_valid(fade_in)):
		#remove_child(fade_in)
		#fade_in.free()

func start_fade_out():
	pass
	fade_out = get_tree().create_tween()
	fade_out.tween_property(audio_player, "volume_db",
		0, 0).set_trans(Tween.TRANS_LINEAR)
	fade_out.tween_property(audio_player, "volume_db",
		-30, 2.5).set_trans(Tween.TRANS_LINEAR)
	
	fade_out.play()

func start_fade_in():
	fade_in = get_tree().create_tween()
	fade_in.tween_property(audio_player, "volume_db",
		-30, 0).set_trans(Tween.TRANS_LINEAR)
	fade_in.tween_property(audio_player, "volume_db",
		0, 1).set_trans(Tween.TRANS_LINEAR)
	fade_in.play()

func play_random_once_song():
	var rand_nb = rng.randi_range(3, Global.BGM_LIST.size()-1)
	Global.BGM_ID = rand_nb
	play_song(Global.BGM_ID)

func play_random_all_song():
	var rand_nb = rng.randi_range(3, Global.BGM_LIST.size()-1)
	play_song(rand_nb)

func reset_seek():
#	print("reset_seek")
	seek_point = 0.0

func set_seek():
	if (Global.BGM_ID == 2):
		reset_seek()
	elif (current_song == "AngelInstall"):
		reset_seek()
	elif (current_song == ""):
		pass
	else:
#		print("set seek point")
		seek_point = audio_player.get_playback_position()

func play_song(id: int):
	if (id < 3 or id >= Global.BGM_LIST.size()):
		push_error(str(id) + " out of bounds BGM")
	current_song = Global.BGM_LIST[id]
	var uid = Global.BGM_UID_LIST[id]
	var audiostream = load(uid)
	audio_player.set_stream(audiostream)
#	print(seek_point)
#	print(current_song)
	audio_player.play(seek_point)

func start_music():
	if (Global.BGM_ID == 0):
		play_song(character_id_to_bgm_id())
	elif (Global.BGM_ID == 1):
		play_random_once_song()
	elif (Global.BGM_ID == 2):
		play_random_all_song()
	else:
		play_song(Global.BGM_ID)

func character_id_to_bgm_id() -> int:
	var point_id = Global.PLAYER_2_CHARACTER[0]
	var assist_id = Global.PLAYER_2_CHARACTER[1]
	if (Global.BGM_IS_P1_SIDE):
		point_id = Global.PLAYER_1_CHARACTER[0]
		assist_id = Global.PLAYER_1_CHARACTER[1]
	
	var out_id: int = Global.BGM_LIST.find("This MU is (2-8) At Best")
	if (Global.BGM_IS_ASSIST):
		match assist_id:
			Enums.AssistCharacters.Subaru:
				out_id = Global.BGM_LIST.find("Pleiades")
			Enums.AssistCharacters.Mio:
				out_id = Global.BGM_LIST.find("Howling")
			Enums.AssistCharacters.Oga:
				out_id = Global.BGM_LIST.find("Silent Night Requiem")
			Enums.AssistCharacters.Ollie:
				pass
			Enums.AssistCharacters.Suisei:
				pass
			Enums.AssistCharacters.Kanata:
				out_id = Global.BGM_LIST.find("Chuuku No Niwa")
			Enums.AssistCharacters.OkaKoro:
				out_id = Global.BGM_LIST.find("Detabare Neko")
			Enums.AssistCharacters.Sana:
				out_id = Global.BGM_LIST.find("The Wahphony")
			Enums.AssistCharacters.Hakka:
				out_id = Global.BGM_LIST.find("Battle at the Top of the World")
			Enums.AssistCharacters.Fubuki:
				pass
			Enums.AssistCharacters.Sora:
				pass
	else:
		match point_id:
			Enums.PointCharacters.Subaru:
				out_id = Global.BGM_LIST.find("Pleiades")
			Enums.PointCharacters.Mio:
				out_id = Global.BGM_LIST.find("Howling")
			Enums.PointCharacters.Oga:
				out_id = Global.BGM_LIST.find("Silent Night Requiem")
			Enums.PointCharacters.Kanata:
				out_id = Global.BGM_LIST.find("Chuuku No Niwa")
			Enums.PointCharacters.Suisei:
				pass
			Enums.PointCharacters.Ollie:
				pass
	# Team Specific Special Songs 
	match point_id:
		Enums.PointCharacters.Subaru:
			if (assist_id == Enums.AssistCharacters.Subaru):
				out_id = Global.BGM_LIST.find("Homenobi")
			elif (assist_id == Enums.AssistCharacters.OkaKoro):
				out_id = Global.BGM_LIST.find("Mogu Mogu Yummy")
		Enums.PointCharacters.Mio:
			if (assist_id == Enums.AssistCharacters.Mio):
				out_id = Global.BGM_LIST.find("Yume Hanabi")
			elif (assist_id == Enums.AssistCharacters.Fubuki):
				out_id = Global.BGM_LIST.find("Howling") # TODO: Hozuki
			elif (assist_id == Enums.AssistCharacters.OkaKoro):
				out_id = Global.BGM_LIST.find("Saikyo Tensai")
		Enums.PointCharacters.Oga:
			if (assist_id == Enums.AssistCharacters.Oga):
				out_id = Global.BGM_LIST.find("Beginning")
			if (assist_id == Enums.AssistCharacters.Fubuki):
				out_id = Global.BGM_LIST.find("WIM")
			elif (assist_id == Enums.AssistCharacters.Hakka):
				out_id = Global.BGM_LIST.find("Just Follow Stars")
		Enums.PointCharacters.Kanata:
			if (assist_id == Enums.AssistCharacters.Kanata):
				out_id = Global.BGM_LIST.find("Palette")
		Enums.PointCharacters.Ollie:
			if (assist_id == Enums.AssistCharacters.Ollie):
				pass
		Enums.PointCharacters.Suisei:
			if (assist_id == Enums.AssistCharacters.Suisei):
				pass
				#out_id = Global.BGM_LIST.find("Maintenance")
			if (assist_id == Enums.AssistCharacters.Sora):
				pass
				#out_id = Global.BGM_LIST.find("Little Bit")
	
	if (Global.PLAYER_1_CHARACTER[0] == Global.PLAYER_2_CHARACTER[0]):
		out_id = Global.BGM_LIST.find("This MU is (2-8) At Best")
		print("Mirror match!")
	return out_id
	
func fade_out_music():
	# rely on tweens
	stop_fade_in()
	start_fade_out()
	set_seek()

func fade_in_music():
	audio_player.volume_db = -70
	start_fade_in()

func play_win_song():
	stop_fade_out()
	var audiostream = load('res://game/assets/music/' + 'WinSpiralTones' + '.ogg')
	current_song = "WinSpiralTones"
	audio_player.set_stream(audiostream)
	audio_player.play(0)
	audio_player.volume_db = 0

func play_main_menu_music():
	if (current_song != "MainMenu"):
		audio_player.stream = menu_music
		current_song = "MainMenu"
		audio_player.play()

func stop_music():
	current_song = ""
	audio_player.stop()

func play_title_screen_music():
	current_song = "TitleScreen"
	var audiostream = load('res://game/assets/music/' + 'TitleWaves' + '.ogg')
	audio_player.stream = audiostream
	audio_player.play()

func play_angel_install_music(is_comeback=false):
	if (current_song != "AngelInstall"):
		if (Global.IS_TRAINING):
			audio_player.stream = angel_training_music
		else:
			if (is_comeback):
				audio_player.stream = angel_comeback_music
			else:
				audio_player.stream = angel_music
		current_song = "AngelInstall"
		audio_player.play()
		audio_player.volume_db = 0

func play_character_select_music():
	audio_player.stream = character_select_music
	current_song = "CharacterSelect"
	audio_player.play()
