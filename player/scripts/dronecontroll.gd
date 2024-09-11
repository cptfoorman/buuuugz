extends Node2D
class_name DroneControl


@onready var path_2d: Path2D = %Path2D
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var drone_marker: Marker2D = %Marker2D
@export var current_drone: PackedScene
@export var spawn_marker: Marker2D
var active_drone: DroneBase = null
var current_drone_type: int = 3
@export var bullet_strategy_array: Array [BaseBulletStrategy] = []

var enemy_in_range: bool = false

func _process(delta: float) -> void:
	if !enemy_in_range:
		path_follow_2d.progress_ratio += delta/3.0
	else:
		pass
		
func spawn_drone():
	if current_drone!= null:
		var new_drone = current_drone.instantiate()
		var level: Level = get_tree().get_first_node_in_group("level")
		level.main_tilemap_layer.add_child(new_drone)
		new_drone.global_position = spawn_marker.global_position
		active_drone = new_drone
		for strategy in bullet_strategy_array:
			active_drone.bullet_strategy_array.append(strategy)
		current_drone_type = active_drone.drone_type
func clear_current_drone():
	if active_drone!= null:
		active_drone.queue_free()
		active_drone = null
	else:
		pass
		
