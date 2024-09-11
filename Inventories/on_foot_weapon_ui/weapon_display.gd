extends PanelContainer
class_name WeaponDisplay

var equipped_weapon_display: bool = false
@onready var weaponname = %weaponname
@onready var icon = %TextureRect
@onready var equip = %equip
@onready var unequip = %unequip
@onready var dropbackpack: Button = %dropbackpack
@onready var dropbelt: Button = %dropbelt


var item_reference: Item
signal Unequip
signal DropBelt
signal DropBackpack
signal Equip
func display(item: Item):
	weaponname.text = item.item_name
	icon.texture = item.item_icon
	item_reference = item

func set_equipped():
	equip.visible = false
	equip.disabled = true
	dropbackpack.visible = false
	dropbackpack.disabled = true
func set_unequipped():
	unequip.visible = false
	unequip.disabled = true
	dropbelt.visible = false
	dropbelt.disabled = true


func _on_equip_pressed():
	Equip.emit(item_reference)
	queue_free()

func _on_unequip_pressed():
	Unequip.emit(item_reference)
	queue_free()




func _on_dropbackpack_pressed() -> void:
	DropBackpack.emit(item_reference)
	queue_free()


func _on_dropbelt_pressed() -> void:
	DropBelt.emit(item_reference)
	queue_free()
