extends Control
class_name WeaponShopUI

@onready var player_grid: GridContainer = %PlayerGrid
@onready var playersells: GridContainer = %playersells
@onready var playerbuys: GridContainer = %playerbuys
@onready var shop_grid: GridContainer = %ShopGrid

@onready var player_money_count: Label = %player_money_count
@onready var total_cost_count: Label = %total_cost_count

@onready var accept: Button = %accept


var total_cost: int = 0
var player_money: int = 0
@export var display_slot: PackedScene

var current_shop_array: Array[Item] = []
var current_player_array: Array[Item] = []
var current_shop_selling_array: Array[Item] = []
var current_player_selling_array: Array[Item] = []

signal ShoppingOver

func open(player_weapon_inventory: WeaponInventory, shop_weapon_inventory: ShopkeepInventory ):
	show()
	clear_displays()
	player_money = GlobalCurrency.coins
	for item in player_weapon_inventory.get_belt_inventory():
		var new_slot = display_slot.instantiate()
		player_grid.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_sellable()
		new_slot.connect("Sell", _on_weapon_shop_display_sell)
		add_player_shop_item(item)
	for item in player_weapon_inventory.get_backpack_inventory():
		var new_slot = display_slot.instantiate()
		player_grid.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_sellable()
		new_slot.connect("Sell", _on_weapon_shop_display_sell)
		add_player_shop_item(item)
	for item in shop_weapon_inventory.get_shop_inventory():
		var new_slot = display_slot.instantiate()
		shop_grid.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_buyable()
		new_slot.connect("Buy", _on_weapon_shop_display_buy)
		add_shopkeep_item(item)
func _process(delta):
	total_cost_count.text = str(total_cost)
	player_money_count.text = str(player_money)
	if total_cost > player_money:
		accept.disabled = true
	else:
		accept.disabled = false
func clear_displays():
	for child in player_grid.get_children():
		child.queue_free()
	for child in playersells.get_children():
		child.queue_free()
	for child in playerbuys.get_children():
		child.queue_free()
	for child in shop_grid.get_children():
		child.queue_free()

func add_player_shop_item(item: Item):
	current_player_array.append(item)

func add_shopkeep_item(item: Item):
	current_shop_array.append(item)
func add_player_item_to_sell_table(item: Item):
	current_player_selling_array.append(item)

func add_shopkeep_item_to_buy_table(item: Item):
	current_shop_selling_array.append(item)
	
func _on_weapon_shop_display_buy(item: Item):
	current_shop_array.erase(item)
	var new_slot = display_slot.instantiate()
	playerbuys.add_child(new_slot)
	new_slot.display(item)
	new_slot.set_returnable()
	new_slot.set_from_shop_item()
	new_slot.connect("GiveBack",_on_weapon_shop_display_give_back)
	add_shopkeep_item_to_buy_table(item)
	total_cost += item.item_value
	


func _on_weapon_shop_display_give_back(item: Item, item_from_shop: bool):
	if item_from_shop == true:
		current_shop_selling_array.erase(item)
		var new_slot = display_slot.instantiate()
		shop_grid.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_buyable()
		new_slot.connect("Buy", _on_weapon_shop_display_buy)
		add_shopkeep_item(item)
		total_cost -= item.item_value
	else:
		current_player_selling_array.erase(item)
		var new_slot = display_slot.instantiate()
		player_grid.add_child(new_slot)
		new_slot.display(item)
		new_slot.set_sellable()
		new_slot.connect("Sell", _on_weapon_shop_display_sell)
		add_player_shop_item(item)
		total_cost += item.item_value


func _on_weapon_shop_display_sell(item: Item):
	current_player_array.erase(item)
	var new_slot = display_slot.instantiate()
	playersells.add_child(new_slot)
	new_slot.display(item)
	new_slot.set_returnable()
	new_slot.connect("GiveBack", _on_weapon_shop_display_give_back)
	add_player_item_to_sell_table(item)
	total_cost -= item.item_value
	



func _on_accept_pressed():
	current_player_array.append_array(current_shop_selling_array)
	current_shop_array.append_array(current_player_selling_array)
	ShoppingOver.emit()
	GlobalCurrency.coins -= total_cost
	total_cost = 0
	hide()


func _on_decline_pressed():
	current_player_array.append_array(current_player_selling_array)
	current_shop_array.append_array(current_shop_selling_array)
	ShoppingOver.emit()
	total_cost = 0
	hide()
