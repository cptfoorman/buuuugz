extends Node2D
class_name Cpoor


@export var c4: Item
@export var dispense_pickup: PackedScene
@export var dispense_marker: Marker2D
@export var cost: int
var player : Player = null
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if player:
		if GlobalCurrency.score >= 1000:
			if Input.is_action_just_pressed("interact"):
				dispense_c4()
				animation_player.play("dispense")
				GlobalCurrency.score -= 1000


func dispense_c4():
	var new_dispense = dispense_pickup.instantiate()
	new_dispense.item = c4
	dispense_marker.add_child(new_dispense)
	new_dispense.global_position = dispense_marker.global_position

func dispense_c4_red():
	var new_dispense = dispense_pickup.instantiate()
	new_dispense.item = c4
	dispense_marker.add_child(new_dispense)
	new_dispense.global_position = dispense_marker.global_position
	GlobalCurrency.mantis_red_heads_current -= 3

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
