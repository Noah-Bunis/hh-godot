extends Node2D

var hp_bar: Node

var highest_combo_damage: int

func tick():
	if (hp_bar.get_attack_damage() != 0):
		$AttackDamage.text = tr("UI_LABEL_ATTACK_DAMAGE")+str(hp_bar.get_attack_damage())
	if (hp_bar.get_combo_damage() != 0):
		$ComboDamage.text = tr("UI_LABEL_COMBO_DAMAGE")+str(hp_bar.get_combo_damage())
