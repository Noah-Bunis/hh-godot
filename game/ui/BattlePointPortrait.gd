extends Sprite2D

@onready var character_sprite = $Sprite2D

func load_portrait(enum_point_chara, point_color, enum_assist_chara, assist_color) -> void:
	var portrait = ""
	character_sprite.material.set_shader_parameter("palette", point_color)
	match enum_point_chara:
		Enums.PointCharacters.Subaru:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SubaruButtonReal.png"
		Enums.PointCharacters.Mio:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/MioButtonReal.png"
		Enums.PointCharacters.Oga:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/OgaButtonReal.png"
		Enums.PointCharacters.Ollie:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/OllieButtonReal.png"
		Enums.PointCharacters.Kanata:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/KanataButtonReal.png"
		Enums.PointCharacters.Suisei:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SuiseiButtonReal.png"
		Enums.PointCharacters.Flayon:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/FlayonButtonReal.png"
		Enums.PointCharacters.Kurokami:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SubaruButtonReal.png"
		_:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SubaruButtonReal.png"
	character_sprite.texture = load(portrait)
	
	$AssistBattlePortrait/Sprite2D.material.set_shader_parameter("palette", assist_color)
	match enum_assist_chara:
		Enums.AssistCharacters.Fubuki:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/FubukiButtonReal.png"
		Enums.AssistCharacters.Sora:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SoraButtonReal.png"
		Enums.AssistCharacters.Sana:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SanaButtonReal.png"
		Enums.AssistCharacters.OkaKoro:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/OkaKoroButtonReal.png"
		Enums.AssistCharacters.Hakka:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/HakkaButtonReal.png"
		Enums.AssistCharacters.Subaru:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SubaruButtonReal.png"
		Enums.AssistCharacters.Mio:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/MioButtonReal.png"
		Enums.AssistCharacters.Oga:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/OgaButtonReal.png"
		Enums.AssistCharacters.Ollie:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/OllieButtonReal.png"
		Enums.AssistCharacters.Kanata:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/KanataButtonReal.png"
		Enums.AssistCharacters.Suisei:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/SuiseiButtonReal.png"
		Enums.AssistCharacters.Flayon:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/FlayonButtonReal.png"
		_:
			portrait = "res://game/assets/sprites/UI/CharacterSelect/MiniPortraits/FubukiButtonReal.png"
	$AssistBattlePortrait/Sprite2D.texture = load(portrait)
