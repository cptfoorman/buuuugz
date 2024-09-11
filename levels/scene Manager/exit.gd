extends Area2D
class_name Exit
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@onready var levelmanager: SceneManager = get_tree().get_first_node_in_group("manager")
	
	
var playerin: bool = false
func _unhandled_input(event: InputEvent) -> void:
	if playerin == true:
		if Input.is_action_just_released("interact"):
			levelmanager.exit_mission_ui.show()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		playerin = true
		animated_sprite.play("expand")


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		playerin = false
		animated_sprite.play("retract")
