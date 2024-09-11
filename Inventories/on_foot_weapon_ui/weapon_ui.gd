extends PanelContainer
class_name WeaponUI

@onready var backpack_container = %backpack_container
@onready var belt_container = %belt_container
@export var weapon_slot: PackedScene
@export var item_dispenser: PackedScene
var current_backpack_array: Array[Item] = []
var current_belt_array: Array[Item] = []

signal InventoryReorganized


func open(inventory: WeaponInventory):
	show()
		#clears display for eq weapons
	for child in belt_container.get_children():
		child.queue_free()
		#clears display for uneq weapons
	for child in backpack_container.get_children():
		child.queue_free()
	for item in inventory.get_belt_inventory():
		var new_slot = weapon_slot.instantiate()
		belt_container.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_equipped()
		new_slot.connect("Unequip", _on_weapon_display_unequip)
		new_slot.connect("DropBelt", _on_weapon_display_drop_belt)
		add_belt_item(item)
	for item in inventory.get_backpack_inventory():
		var new_slot = weapon_slot.instantiate()
		backpack_container.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_unequipped()
		new_slot.connect("Equip", _on_weapon_display_equip)
		new_slot.connect("DropBackpack", _on_weapon_display_drop_backpack)
		add_backpack_item(item)

func _on_exit_button_pressed():
	hide()
	InventoryReorganized.emit()
	


func _on_weapon_display_unequip(item: Item):
	current_belt_array.erase(item)
	var new_slot = weapon_slot.instantiate()
	backpack_container.add_child(new_slot)
	new_slot.display(item)
	new_slot.set_unequipped()
	new_slot.connect("Equip", _on_weapon_display_equip)
	new_slot.connect("DropBackpack", _on_weapon_display_drop_backpack)
	add_backpack_item(item)


func _on_weapon_display_equip(item: Item):
	current_backpack_array.erase(item)
	var new_slot = weapon_slot.instantiate()
	belt_container.add_child(new_slot)
	new_slot.display(item)
	new_slot.set_equipped()
	new_slot.connect("Unequip", _on_weapon_display_unequip)
	new_slot.connect("DropBelt", _on_weapon_display_drop_belt)
	add_belt_item(item)

func remove_belt_item(item: Item):
	current_belt_array.erase(item)

func remove_backpack_item(item: Item):
	current_backpack_array.erase(item)
func add_belt_item(item: Item):
	current_belt_array.append(item)

func add_backpack_item(item: Item):
	current_backpack_array.append(item)



	


func _on_weapon_display_drop_backpack(item: Item) -> void:
	current_backpack_array.erase(item)
	var new_pickup: ItemPickup = item_dispenser.instantiate()
	new_pickup.item = item
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.add_sibling(new_pickup)
	new_pickup.global_position = player.global_position


func _on_weapon_display_drop_belt(item: Item) -> void:
	current_belt_array.erase(item)
	var new_pickup: ItemPickup = item_dispenser.instantiate()
	new_pickup.item = item
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.add_sibling(new_pickup)
	new_pickup.global_position = player.global_position
