extends Node


var eggs_killed: int
var difficulty_modifier: int = 1
var bughole_count: int = 4
enum Objective {EGGS, CP}
@export var objectives: Objective = Objective.CP

var eggs_destroyed_current: int = 0
var holes_destroyed_current: int = 0

var holes_to_destroy: int = 4
var eggs_to_destroy: int = 9

var exit_open : bool = false
var in_mission: bool = false
func randomize_objective():
	var rn = randi_range(1,2)
	if rn == 1:
		objectives = Objective.EGGS
	elif rn == 2:
		objectives = Objective.CP
func _process(delta: float) -> void:
	match objectives:
		Objective.EGGS:
			if eggs_destroyed_current < eggs_to_destroy:
				exit_open = false
			else:
				exit_open = true
		Objective.CP:
			if holes_destroyed_current < holes_to_destroy:
				exit_open = false
			else:
				exit_open = true
func pause():
	get_tree().paused = true
func unpause():
	get_tree().paused = false
