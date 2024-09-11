class_name WeaponInventory

var belt_contents: Array [Item] = []
var backpack_contents: Array [Item] = []

func add_belt_item(item: Item):
	belt_contents.append(item)

func add_backpack_item(item: Item):
	backpack_contents.append(item)
func remove_belt_item(item: Item):
	belt_contents.erase(item)

func remove_backpack_item(item: Item):
	backpack_contents.erase(item)

func get_belt_inventory() -> Array:
	return belt_contents
func get_backpack_inventory() -> Array:
	return backpack_contents

func remove_c4():
	for i in belt_contents:
		if i.is_c4 == true:
			remove_belt_item(i)
