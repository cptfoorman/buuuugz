class_name ShopkeepInventory

var shop_items_array: Array[Item]= [] 


func add_item(item: Item):
	shop_items_array.append(item)
	
func remove_item(item: Item):
	shop_items_array.erase(item)

func set_shop_inventory(item_array: Array[Item]):
	shop_items_array.append_array(item_array)
func get_shop_inventory()-> Array:
	return shop_items_array
