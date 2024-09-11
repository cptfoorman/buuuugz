extends Node2D
class_name Level

@export var main_tilemap_layer: TileMapLayer#to identify where to add enemies as to enable y sort and stuff later
@export var spawn_point: Marker2D#player spawn point


@export var marker_stash: Node2D
@export var spawner_stash: Node2D#stash for markers to get easily indentified for spawning
@export var shinyrock_stash: Node2D


@export var cam_shake_area: CamShakeArea#for the spawner increased timeout effect

func _ready() -> void:#ensure the shake hurtbox is disabled
	if cam_shake_area != null:
		cam_shake_area.collision.disabled = true

func spawners_increased_shake():#shakes the player viewpoint amount configurable on the scene node
	cam_shake_area.collision.disabled = false
	await get_tree().create_timer(0.2).timeout
	cam_shake_area.collision.disabled = true
