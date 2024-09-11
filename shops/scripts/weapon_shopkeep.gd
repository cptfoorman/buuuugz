extends StaticBody2D
class_name WeaponShopkeep

@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var possible_items_array: Array[Item]
@export var shopkeep_item_count: int
@onready var weapon_shop_ui: WeaponShopUI = %WeaponShopUI

var shopkeep_inventory: ShopkeepInventory = ShopkeepInventory.new()
var player: Player = null
var shop_is_open:bool = false
@onready var bye: AudioStreamPlayer = %bye
@onready var welcome: AudioStreamPlayer = %welcome
var saved_player_speed: float
func _ready():
	anim_sprite.play("default")
	for i in shopkeep_item_count:
		var new_item = possible_items_array.pick_random()
		shopkeep_inventory.add_item(new_item)
func _unhandled_input(event):
	if player:
		if shop_is_open == false:
			if Input.is_action_just_pressed("interact"):
				weapon_shop_ui.open(player.weapon_inventory, shopkeep_inventory)
				clear_player_active_weapons()
				welcome.play()
				shop_is_open = true
				saved_player_speed = player.current_speed
				player.current_speed = 0
				player.hide_ui_for_shop()


func _on_area_2d_body_entered(body):
	if body is Player:
		print("hello")
		player = body
		


func _on_area_2d_body_exited(body):
	if body is Player:
		print("no hello")
		player = null
		

func add_item_to_shop(item: Item):
	shopkeep_inventory.add_item(item)
	
func clear_weapon_shop_ui_temp_array():
	weapon_shop_ui.current_shop_array.resize(0)
	weapon_shop_ui.current_player_array.resize(0)
	weapon_shop_ui.current_shop_selling_array.resize(0)
	weapon_shop_ui.current_player_selling_array.resize(0)
func clear_player_weapon_inventory():
	player.weapon_inventory.backpack_contents.resize(0)
	player.weapon_inventory.belt_contents.resize(0)
func clear_player_active_weapons():
	for child in player.hands.get_children():
		child.queue_free()
	
	
	for child in player.weapon_backpack.hands.get_children():
		child.queue_free()
	
	for child in player.weapon_backpack.get_children():
		child.queue_free()
	
	player.weapon_backpack.current_weapon = null
	player.weapon_backpack.weapon1 = null
	player.weapon_backpack.weapon2 = null
	player.weapon_backpack.weapon3 = null
	
func clear_shopkeep_inventory():
	shopkeep_inventory.shop_items_array.resize(0)
func shoppers_pick_up_new_contents():
	for item in weapon_shop_ui.current_player_array:
		player.weapon_backpack.weapon_pickup(item)
	for item in weapon_shop_ui.current_shop_array:
		add_item_to_shop(item)


func _on_weapon_shop_ui_shopping_over():
	clear_shopkeep_inventory()
	clear_player_weapon_inventory()
	await get_tree().create_timer(0.1).timeout
	shoppers_pick_up_new_contents()
	await get_tree().create_timer(0.1).timeout
	clear_weapon_shop_ui_temp_array()
	bye.play(randi_range(0,1))
	shop_is_open = false
	player.current_speed = saved_player_speed
	player.show_ui()
	
