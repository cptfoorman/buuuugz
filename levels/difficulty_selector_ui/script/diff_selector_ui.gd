extends Control
class_name DiffUI


signal DifficultySet

@onready var mantis: TextureRect = $VBoxContainer/current_enemies/mantis
@onready var redmantis: TextureRect = $VBoxContainer/current_enemies/redmantis
@onready var chrobus: TextureRect = $VBoxContainer/current_enemies/chrobus

@onready var objective_eggs_texture: TextureRect = %objective_eggs_texture
@onready var objective_eggs_description: Label = %objective_eggs_description
@onready var objective_2_texture: TextureRect = %objective_2_texture
@onready var objective_2_description: Label = %objective_2_description
@onready var bughole_amount: Label = %bughole_amount
@onready var current_dificulty_count: Label = %current_dificulty_count
@onready var diff_up: Button = %diff_up
@onready var diff_down: Button = %diff_down

enum Current_Objective {EGGS, CP}
@export var current_objectives: Current_Objective


func check_objectives():
	match current_objectives:
		Current_Objective.EGGS:
			objective_eggs_description.show()
			objective_eggs_texture.show()
			objective_2_texture.hide()
			objective_2_description.hide()
		Current_Objective.CP:
			objective_eggs_description.hide()
			objective_eggs_texture.hide()
			objective_2_texture.show()
			objective_2_description.show()
func check_heads():
	if GlobalDifficulty.difficulty_modifier == 1 or GlobalDifficulty.difficulty_modifier == 2:
		mantis.show()
		redmantis.hide()
		chrobus.hide()
	elif GlobalDifficulty.difficulty_modifier == 3:
		redmantis.show()
		chrobus.hide()
	elif GlobalDifficulty.difficulty_modifier == 4:
		redmantis.show()
		chrobus.show()
	else:
		redmantis.hide()
		chrobus.hide()
func set_objective():
	match GlobalDifficulty.objectives:
		GlobalDifficulty.Objective.EGGS:
			current_objectives = Current_Objective.EGGS
		GlobalDifficulty.Objective.CP:
			current_objectives = Current_Objective.CP

func _process(delta: float) -> void:
	bughole_amount.text = str(GlobalDifficulty.bughole_count)
	current_dificulty_count.text = str(GlobalDifficulty.difficulty_modifier)
	set_objective()
	check_objectives()
	check_heads()

func _on_diff_up_pressed() -> void:
	if GlobalDifficulty.difficulty_modifier <= 3:
		GlobalDifficulty.difficulty_modifier += 1
		GlobalDifficulty.bughole_count += 1
		GlobalDifficulty.randomize_objective()
	else:
		pass
		


func _on_diff_down_pressed() -> void:
	if GlobalDifficulty.difficulty_modifier != 1:
		GlobalDifficulty.difficulty_modifier -= 1
		GlobalDifficulty.bughole_count -= 1
		GlobalDifficulty.randomize_objective()
	else:
		pass
		


func _on_embark_pressed() -> void:
	self.hide()
	DifficultySet.emit()


func _on_exit_pressed() -> void:
	self.hide()
