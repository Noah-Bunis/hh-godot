extends Sprite2D

@export var xOffset: int
@export var speed: int

var ticks: int = 10
var tick: int = 0

var character_color_path: String = ""

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (tick > 0):
		self.position.x += speed
		tick -= 1

func change_portrait_anim():
	self.position.x = xOffset - (ticks * speed)
	tick = ticks

func clear_portrait():
	self.texture = null
	$Name.texture = null

func change_color_number(color_number: int):
	var color_texture = load(character_color_path+str(color_number)+".png")
	self.material.set_shader_parameter("palette", color_texture)

func change_color_path(color):
	var color_texture = load(color)
	self.material.set_shader_parameter("palette", color_texture)

func change_portrait(enumChara: int, is_assist=false):
	var portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
	var color = "res://game/assets/sprites/subaru/ColorPalettes/" 
	if (is_assist):
		match enumChara:
			Enums.AssistCharacters.Subaru:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.AssistCharacters.Mio:
				color = "res://game/assets/sprites/mio/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/MioPortrait"
			Enums.AssistCharacters.Oga:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/OgaPortrait"
			Enums.AssistCharacters.Ollie:
				color = "res://game/assets/sprites/ollie/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/OlliePortrait"
			Enums.AssistCharacters.Suisei:
				color = "res://game/assets/sprites/suisei/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SuiseiPortrait"
			Enums.AssistCharacters.Kanata:
				color = "res://game/assets/sprites/kanata/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/KanataPortrait"
			Enums.AssistCharacters.Flayon:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Eight:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Nine:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Ten:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Eleven:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Twelve:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Fubuki:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
			Enums.AssistCharacters.Sora:
				color = "res://game/assets/sprites/assists/sora/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SoraPortrait"
			Enums.AssistCharacters.OkaKoro:
				color = "res://game/assets/sprites/assists/okakoro/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/OkakoroPortrait"
			Enums.AssistCharacters.Hakka:
				color = "res://game/assets/sprites/assists/hakka/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/HakkaPortrait"
			Enums.AssistCharacters.Sana:
				color = "res://game/assets/sprites/assists/sana/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SanaPortrait"
			Enums.AssistCharacters.Random:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/RandomPortrait"
			_:
				color = "res://game/assets/sprites/assists/fubuki/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/FubukiPortrait"
	else:
		match enumChara:
			Enums.PointCharacters.Subaru:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Mio:
				color = "res://game/assets/sprites/mio/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/MioPortrait"
			Enums.PointCharacters.Oga:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/OgaPortrait"
			Enums.PointCharacters.Ollie:
				color = "res://game/assets/sprites/ollie/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/OlliePortrait"
			Enums.PointCharacters.Suisei:
				color = "res://game/assets/sprites/suisei/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SuiseiPortrait"
			Enums.PointCharacters.Kanata:
				color = "res://game/assets/sprites/kanata/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/KanataPortrait"
			Enums.PointCharacters.Flayon:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/RandomPortrait"
			Enums.PointCharacters.Kurokami:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Nine:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Ten:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Eleven:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Twelve:
				color = "res://game/assets/sprites/oga/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/SubaruPortrait"
			Enums.PointCharacters.Random:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/UI/CharacterSelect/Portraits/RandomPortrait"
			_:
				color = "res://game/assets/sprites/subaru/ColorPalettes/"
				portrait = "res://game/assets/sprites/subaru/SubaruPortrait"
	
	character_color_path = color
	self.texture = load(portrait + ".png")
	$Name.texture = load(portrait + "Name.png")
	change_color_path(character_color_path+str(1)+".png")
