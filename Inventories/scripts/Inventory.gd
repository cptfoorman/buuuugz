class_name Inventory

var inventory_items: Array[Item]= []


func add_item(item: Item):
	inventory_items.append(item)
	
func remove_item(item: Item):
	inventory_items.erase(item)
func add_stackable_item(item: Item):
	var has_new_item = inventory_items.find(item)
	if has_new_item == -1:
		inventory_items.append(item)
	else:
		var new_item_stack = item
		print(new_item_stack.amount, " prestack")
		new_item_stack.amount += 1
		print(new_item_stack.amount, " posstack")
		inventory_items.erase(item)
		inventory_items.append(new_item_stack)
	
	
			
func get_inventory()-> Array[Item]:
	return inventory_items
