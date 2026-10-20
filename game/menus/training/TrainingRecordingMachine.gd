class_name TrainingRecordingMachine

var recordings = []
var recordings_size = []
var temp_recording = []

var section: int = 0
var index:int = 0

const size = 5
const max_recording_size = 3600

func _init():
	recordings.resize(size)
	fillWith(recordings_size, 0, size)
	fillWith(temp_recording, 0, max_recording_size)
	for i in range(0, size):
		var empty_inputs = []
		fillWith(empty_inputs, 0, max_recording_size)
		recordings[i] = empty_inputs

func fillWith(array, contents, size):
	for i in range(size):
		array.push_back(contents)

func switch_section(new_section=0):
	if (new_section < 0 or new_section >= size):
		printerr("training recording section out of bounds!")
	self.index = 0
	self.section = new_section

func record_input(new_input:int):
	if (self.index < max_recording_size):
		temp_recording[self.index] = new_input
		self.index += 1

func save_recording():
	for i in range(0, self.index):
		recordings[self.section][i] = temp_recording[i]
	recordings_size[self.section] = self.index
	save_recording_to_file("user://training_recording.dat")
	self.index = 0

func save_recording_to_combo_trial(combo_index: int, character_enum: int, is_assist_combo: bool = false):
	for i in range(0, self.index):
		recordings[self.section][i] = temp_recording[i]
	recordings_size[self.section] = self.index
	var file_path = get_combo_trial_file_path(combo_index, character_enum, is_assist_combo)
	save_recording_to_file(file_path)
	self.index = 0

func get_combo_trial_file_name(combo_index: int, character_enum: int, is_assist_combo: bool = false) -> String:
	var prefix = "assist" if is_assist_combo else "point"
	var character_name = get_character_enum_name(character_enum, is_assist_combo)
	return "%s_%s_trial_%d.dat" % [prefix, character_name.to_lower(), combo_index]

func get_combo_trial_file_path(combo_index: int, character_enum: int, is_assist_combo: bool = false) -> String:
	var file_name = get_combo_trial_file_name(combo_index, character_enum, is_assist_combo)
	return "res://game/ui/combotrialdemos/%s" % file_name

func get_character_enum_name(character_enum: int, is_assist_combo: bool = false) -> String:
	var enum_keys: Array = []
	if is_assist_combo:
		enum_keys = Enums.AssistCharacters.keys()
	else:
		enum_keys = Enums.PointCharacters.keys()
	if character_enum >= 0 and character_enum < enum_keys.size():
		return String(enum_keys[character_enum])
	return "unknown"

func cancel_recording():
	self.index = 0

func read_input(section=0):
	# returns -1 if the read is out of bounds index, error if no section
	if (section < 0 or section >= size):
		printerr("training recording section out of bounds!")
	if (self.index >= 0 and index < recordings_size[section]):
		var read_input:int = recordings[section][self.index]
		self.index += 1
		return read_input
	return -1

func cancel_replay():
	self.index = 0

func has_input(section=0):
	return self.index < recordings_size[section]

func save_recording_to_file(file_path: String):
	var dir_path = file_path.get_base_dir()
	if dir_path != "" and not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		printerr("Could not open recording file for writing: " + file_path)
		return

	var recording_data = {
		"section": self.section,
		"recording_size": recordings_size[self.section],
		"recording": []
	}

	for i in range(0, recordings_size[self.section]):
		recording_data.recording.append(recordings[self.section][i])

	file.store_var(recording_data)
	file.close()

func load_recording_from_file(file_path: String) -> bool:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Could not open recording file for reading: " + file_path)
		return false

	var recording_data = file.get_var()
	file.close()

	if not (recording_data is Dictionary):
		printerr("Invalid recording data format in: " + file_path)
		return false

	var loaded_section = recording_data.get("section", 0)
	var loaded_size = recording_data.get("recording_size", 0)
	var loaded_recording = recording_data.get("recording", [])

	if loaded_section < 0 or loaded_section >= size:
		printerr("Loaded recording section out of bounds: " + str(loaded_section))
		return false

	self.section = loaded_section
	self.index = 0
	self.recordings[loaded_section] = []
	fillWith(self.recordings[loaded_section], 0, max_recording_size)
	for i in range(min(loaded_size, max_recording_size)):
		self.recordings[loaded_section][i] = loaded_recording[i] if i < loaded_recording.size() else 0
	self.recordings_size[loaded_section] = min(loaded_size, max_recording_size)
	return true

func string_recording_frame():
	return "Recording " + str(self.section + 1) + ": " + str(self.index) + "/" + str(self.max_recording_size)

func string_replaying_frame():
	return "Replaying " + ": " + str(self.index)  + "/" + str(recordings_size[self.section])
