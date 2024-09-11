extends PanelContainer
class_name WeaponShopDisplay

@onready var sell = %sell
@onready var returnbutton = %returnbutton
@onready var buy = %buy
@onready var icon = %TextureRect
@onready var weaponname = %weaponname

var item_reference: Item
var item_from_shop: bool

signal Buy
signal Sell
signal GiveBack


func display(item: Item):
	weaponname.text = item.item_name
	icon.texture = item.item_icon
	item_reference = item


func set_buyable():
	sell.visible = false
	sell.disabled = true
	returnbutton.visible = false
	returnbutton.disabled = true

func set_sellable():
	buy.visible = false
	buy.disabled = true
	returnbutton.visible = false
	returnbutton.disabled = true

func set_returnable():
	sell.visible = false
	sell.disabled = true
	buy.visible = false
	buy.disabled = true
func set_from_shop_item():
	item_from_shop = true

func _on_sell_pressed():
	Sell.emit(item_reference)
	queue_free()


func _on_returnbutton_pressed():
	GiveBack.emit(item_reference, item_from_shop)
	queue_free()


func _on_buy_pressed():
	Buy.emit(item_reference)
	queue_free()
