extends Control
class_name ScoreTimeKeeper

@onready var manager: SceneManager = get_tree().get_first_node_in_group("manager")
@onready var time: Label = %time
@onready var score: Label = %score

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	time.text = str(int(manager.difficulty_timeout.time_left))
	score.text = str(GlobalCurrency.score)
