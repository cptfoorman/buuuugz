extends Resource
class_name DroneSwapStrategy


@export var drone_scene: PackedScene
@export var drone_type: int
@export var strategy_name: String


func apply_strategy(control: DroneControl):
	control.current_drone = drone_scene
	control.clear_current_drone()
	control.spawn_drone()
	
