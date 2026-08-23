class_name TrainingRecordingMachine

var recordings = []
var recordings_size = []
var temp_recording = []

var section: int = 0
var index:int = 0

const size = 5
const max_recording_size = 600

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
	self.index = 0

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

func string_recording_frame():
	return "Recording " + str(self.section + 1) + ": " + str(self.index) + "/" + str(self.max_recording_size)

func string_replaying_frame():
	return "Replaying " + ": " + str(self.index)  + "/" + str(recordings_size[self.section])
