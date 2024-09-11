extends Control
class_name MissionProgressUI

@onready var current_count: Label = %current_count
@onready var needed_count: Label = %needed_count
@onready var eggs: TextureRect = %eggs
@onready var holes: TextureRect = %holes


func _process(delta: float) -> void:
	if GlobalDifficulty.in_mission == true:
		match GlobalDifficulty.objectives:
			GlobalDifficulty.Objective.EGGS:
				eggs.show()
				holes.hide()
				needed_count.text = str(GlobalDifficulty.eggs_to_destroy)
				current_count.text = str(GlobalDifficulty.eggs_destroyed_current)
			GlobalDifficulty.Objective.CP:
				eggs.hide()
				holes.show()
				needed_count.text = str(GlobalDifficulty.holes_to_destroy)
				current_count.text = str(GlobalDifficulty.holes_destroyed_current)
