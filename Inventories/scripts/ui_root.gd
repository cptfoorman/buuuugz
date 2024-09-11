extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var weapon_ui: WeaponUI = %WeaponUI

var inv_open: bool = false

func _unhandled_input(event):
	if Input.is_action_just_released("inventory"):
		if inv_open == false:
			weapon_ui.open(player.weapon_inventory)
			clear_player_active_weapons()
			inv_open = true
		elif inv_open == true:
			weapon_ui._on_exit_button_pressed()
			inv_open = false
	if Input.is_action_just_released("escape"):
		if inv_open == true:
			weapon_ui._on_exit_button_pressed()
			inv_open = false

func _on_weapon_ui_inventory_reorganized():
	inv_open = false
	clear_player_weapon_inventory()
	await get_tree().create_timer(0.1).timeout
	player_pick_up_new_contents()
	await get_tree().create_timer(0.1).timeout
	clear_weapon_ui_temp_array()
func clear_player_active_weapons():
	for child in player.hands.get_children():
		child.queue_free()
	
	
	for child in player.hands.get_children():
		child.queue_free()
	
	for child in player.weapon_backpack.get_children():
		child.queue_free()
	
	player.weapon_backpack.current_weapon = null
	player.weapon_backpack.weapon1 = null
	player.weapon_backpack.weapon2 = null
	player.weapon_backpack.weapon3 = null
func player_pick_up_new_contents():
	for item in weapon_ui.current_belt_array:
		player.weapon_backpack.weapon_pickup(item)
	for item in weapon_ui.current_backpack_array:
		player.weapon_backpack.weapon_pickup(item)
func clear_weapon_ui_temp_array():
	weapon_ui.current_belt_array.resize(0)
	weapon_ui.current_backpack_array.resize(0)
func clear_player_weapon_inventory():
	player.weapon_inventory.backpack_contents.resize(0)
	player.weapon_inventory.belt_contents.resize(0)
