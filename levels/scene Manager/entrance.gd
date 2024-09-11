extends Area2D
class_name Entrance

@onready var levelmanager: SceneManager = get_tree().get_first_node_in_group("manager")
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D

var playerin: bool = false
var player: Player = null


func _unhandled_input(event: InputEvent) -> void:
	if playerin == true:
		if Input.is_action_just_released("interact"):
			levelmanager.diff_selector.show()
			player.hide_ui_for_shop()
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		anim_sprite.play("activate")
		player = body
		playerin = true
		
		

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		anim_sprite.play("retract")
		player.show_ui()
		playerin = false
