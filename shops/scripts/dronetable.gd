extends StaticBody2D
class_name DroneTable
@onready var drone_ui: DroneUI = %drone_ui

var player: Player = null
var saved_player_speed: float
var shop_is_open:bool = false
func _ready() -> void:
	drone_ui.hide()

func _unhandled_input(event):
	if player:
		if shop_is_open == false:
			if Input.is_action_just_pressed("interact"):
				drone_ui.show()
				shop_is_open = true
				saved_player_speed = player.current_speed
				player.current_speed = 0
				player.hide_ui_for_shop()
				player.weapon_backpack.current_weapon.can_shoot = false
				
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null


func _on_drone_ui_done_tinkering() -> void:
	drone_ui.hide()
	player.current_speed = saved_player_speed
	shop_is_open = false
	player.show_ui()
	player.weapon_backpack.current_weapon.can_shoot = true
