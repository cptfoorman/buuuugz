extends Area2D
class_name ItemPickup

@export var item: Item
@export var label: Label = null
var player: Player = null
@export var interact: Label


func _ready() -> void:
	var item_scene = item.item_scene.instantiate()
	add_child(item_scene)
	if interact != null:
		interact.hide()
	if label != null:
		label.hide()
		label.text = item.description
		
func _unhandled_input(event: InputEvent) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			player.weapon_backpack.weapon_pickup(item)
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		if interact != null:
			interact.show()



func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		if interact != null:
			interact.hide()


func _on_mouse_entered() -> void:
	if label != null:
		label.show()


func _on_mouse_exited() -> void:
	if label != null:
		label.hide()
