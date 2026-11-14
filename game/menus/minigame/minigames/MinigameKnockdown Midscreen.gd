extends Minigame

const SUBARU_PLAYER_SCENE = preload("res://game/fighter/SubaruPlayer.tscn")

const SAVESTATE: Dictionary = {
"/root/MinigameMain/FighterGame": {
0: true,
1: false,
2: -1,
3: 0,
4: 0
},
"/root/MinigameMain/FighterGame/AssistPlayer1": {
0: "Dormant",
1: "Dormant",
2: false,
3: 0,
4: 0,
5: 0,
6: 0,
7: 0,
8: 0,
9: false,
10: true,
11: 434,
12: 0,
13: -1,
14: -1,
16: 0,
21: 0,
22: 0,
37: 0,
38: -1966080000,
39: 65536,
85: {}
},
"/root/MinigameMain/FighterGame/AssistPlayer1/Hitbox1": {
37: 12189696,
38: -15925248,
39: 1134105,
40: 1114853,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer1/Hitbox2": {
37: 8060928,
38: -12255232,
39: 942229,
40: -901102,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer1/Hurtbox1": {
37: 0,
38: -14337728,
39: 1086985,
40: 1574037,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer1/Hurtbox2": {
37: 65536,
38: -11993090,
39: 408108,
40: 2087212,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer1/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/AssistPlayer2": {
0: "Dormant",
1: "Dormant",
2: false,
3: 0,
4: 0,
5: 0,
6: 0,
7: 0,
8: 0,
9: true,
10: true,
11: 434,
12: 0,
13: -1,
14: -1,
16: 0,
21: 0,
22: 0,
37: 0,
38: -1966080000,
39: -65536,
85: {}
},
"/root/MinigameMain/FighterGame/AssistPlayer2/Hitbox1": {
37: 12189696,
38: -15925248,
39: 1134105,
40: 1114853,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer2/Hitbox2": {
37: 8060928,
38: -12255232,
39: 942229,
40: -901102,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer2/Hurtbox1": {
37: 0,
38: -14337728,
39: 1086985,
40: 1574037,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer2/Hurtbox2": {
37: 65536,
38: -11993090,
39: 408108,
40: 2087212,
41: true
},
"/root/MinigameMain/FighterGame/AssistPlayer2/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/BattleCamera": {
0: -11400944,
1: 0
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ClientComboCounter/CounterAnimation": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ClientComboCounter/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ClientHPBar": {
0: 563,
1: 563,
2: 563,
3: 1.0,
4: true
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/DownText/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/DownText/NetworkTimer": {
&"running": false,
&"ticks_left": 0,
&"wait_ticks": 60
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/IntroShutters/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/IntroShutters/NetworkTimer": {
&"running": true,
&"ticks_left": 8,
&"wait_ticks": 30
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/NowLoadingText/AnnouncerTimer": {
&"running": false,
&"ticks_left": 0,
&"wait_ticks": 135
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/NowLoadingText/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/NowLoadingText/NetworkTimer": {
&"running": false,
&"ticks_left": 0,
&"wait_ticks": 1
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/RoundTimer": {
0: 6000,
1: false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/RoundTimer/CounterAnimation": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/RoundTimer/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/RoundTracker": {
0: 0,
1: 0
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ServerComboCounter/CounterAnimation": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ServerComboCounter/NetworkAnimationPlayer": {
&"current_animation": "",
&"current_position": 0.0,
&"current_speed": 1,
&"is_playing": false
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/ServerHPBar": {
0: 509,
1: 563,
2: 563,
3: 1.0,
4: true
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/WinScreenManager": {
0: false,
1: 0
},
"/root/MinigameMain/FighterGame/Camera3D/BattleUI/WinScreenManager/NetworkTimer": {
&"running": false,
&"ticks_left": 0,
&"wait_ticks": 200
},
"/root/MinigameMain/FighterGame/ClientInputInterpreter/InputSource": {
0: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
1: 38,
2: 0
},
"/root/MinigameMain/FighterGame/Player1": {
0: "HurtLaunch",
1: "HurtLaunch",
2: false,
3: -786432,
4: -1966080,
5: 0,
6: 183500,
7: 0,
8: 0,
9: false,
10: false,
11: 0,
12: 0,
13: 4,
14: -1,
15: "",
16: 61,
17: 1,
18: 4,
19: 1,
20: 1,
21: 0,
22: 0,
23: false,
24: 2621440000,
25: 1966080,
26: 1966080,
27: 3276800000,
28: 490400,
29: 23782688,
30: true,
31: 1,
32: "/root/TrainingMain/FighterGame/Player2",
33: 0,
34: true,
37: -23292288,
38: 29212410,
39: 65536,
85: {}
},
"/root/MinigameMain/FighterGame/Player1/Hitbox1": {
37: 5177342,
38: -23920640,
39: 1015584,
40: 572323,
41: true
},
"/root/MinigameMain/FighterGame/Player1/Hitbox2": {
37: -7208960,
38: -12386305,
39: 710025,
40: 525184,
41: true
},
"/root/MinigameMain/FighterGame/Player1/Hurtbox1": {
37: -1703936,
38: -17367038,
39: 1096960,
40: -1630350,
41: false
},
"/root/MinigameMain/FighterGame/Player1/Hurtbox2": {
37: 0,
38: -7745600,
39: 1273239,
40: 863361,
41: true
},
"/root/MinigameMain/FighterGame/Player1/Hurtbox3": {
37: 1,
38: -27390912,
39: 1001320,
40: 476368,
41: true
},
"/root/MinigameMain/FighterGame/Player1/NetworkAnimationPlayer": {
&"current_animation": "AirHit",
&"current_position": 0.05,
&"current_speed": 0.0,
&"is_playing": true
},
"/root/MinigameMain/FighterGame/Player2": {
0: "Crouch2C",
1: "Crouch2C",
2: false,
3: 0,
4: 0,
5: 0,
6: 0,
7: 75536,
8: 0,
9: true,
10: false,
11: 10,
12: 10,
13: 4,
14: 254,
15: "",
16: 0,
17: 0,
18: 0,
19: 1,
20: 1,
21: 0,
22: 0,
23: true,
24: 2621440000,
25: 3366369,
26: 1966080,
27: 3276800000,
28: -23292288,
29: 23782688,
30: true,
31: 1,
32: "/root/TrainingMain/FighterGame/Player1",
33: 0,
34: false,
37: 490400,
38: 29212410,
39: -65536,
85: {
"Player1": 254
}
},
"/root/MinigameMain/FighterGame/Player2/Hitbox1": {
37: 15400960,
38: -2752512,
39: 1419159,
40: -339693,
41: false
},
"/root/MinigameMain/FighterGame/Player2/Hitbox2": {
37: 12976127,
38: -6029312,
39: 711968,
40: -321020,
41: false
},
"/root/MinigameMain/FighterGame/Player2/Hurtbox1": {
37: 983040,
38: -14548992,
39: 334968,
40: 357786,
41: false
},
"/root/MinigameMain/FighterGame/Player2/Hurtbox2": {
37: -524288,
38: -7471104,
39: 446568,
40: -774072,
41: false
},
"/root/MinigameMain/FighterGame/Player2/Hurtbox3": {
37: 655360,
38: -1835008,
39: 1161459,
40: -231611,
41: false
},
"/root/MinigameMain/FighterGame/Player2/NetworkAnimationPlayer": {
&"current_animation": "2C",
&"current_position": 0.16666666666666666,
&"current_speed": 0.0,
&"is_playing": true
},
"/root/MinigameMain/FighterGame/ServerInputInterpreter/InputSource": {
0: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
1: 38,
2: 0
},
"/root/SyncManager/SpawnManager": {
&"counter": {
"HitVFX": 1,
"TagVFX": 4
},
&"spawn_records": {}
}
}

func _init() -> void:
	display_name = "knockdown_midscreen"
	dummy_point_character = Enums.PointCharacters.Subaru
	dummy_point_scene = SUBARU_PLAYER_SCENE
	savestate = SAVESTATE.duplicate(true)
