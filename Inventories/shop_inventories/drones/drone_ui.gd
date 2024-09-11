extends Control
class_name DroneUI


@export var shotgun_drone: PackedScene
@export var rifle_drone: PackedScene
@export var flame_drone: PackedScene
@onready var drone_control: DroneControl = get_tree().get_first_node_in_group("DroneControl")

signal DoneTinkering

func _on_equipshotgun_pressed() -> void:
	drone_control.current_drone = shotgun_drone


func _on_equip_ar_pressed() -> void:
	drone_control.current_drone = rifle_drone


func _on_equipflame_pressed() -> void:
	drone_control.current_drone = flame_drone


func _on_clear_current_drone_pressed() -> void:
	drone_control.current_drone = null
	drone_control.clear_current_drone()

func _on_accept_pressed() -> void:
	DoneTinkering.emit()
	drone_control.clear_current_drone()
	drone_control.spawn_drone()


func _on_escape_pressed() -> void:
	DoneTinkering.emit()
	drone_control.clear_current_drone()
	drone_control.spawn_drone()
