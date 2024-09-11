extends StaticBody2D
class_name HeadsExchange


@onready var head_selling_ui: HeadSellerUI = %head_selling_ui

var player: Player = null
var saved_player_speed: float

func _unhandled_input(event: InputEvent) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			player.hide_ui_for_shop()
			head_selling_ui.show()
			saved_player_speed = player.current_speed
			player.current_speed = 0
			player.weapon_backpack.current_weapon.can_shoot = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null


func _on_head_selling_ui_exit() -> void:
	head_selling_ui.hide()
	player.show_ui()
	player.current_speed = saved_player_speed
	player.weapon_backpack.current_weapon.can_shoot = true
