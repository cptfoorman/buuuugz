extends BaseWeapon
class_name C4Hand


@export var c4_scene: PackedScene
@export var bomb_plant: AudioStreamPlayer
func _ready() -> void:
	current_ammo = max_ammo

func shoot():
	bomb_plant.play()
	
	
func spawn_c4():
	var new_c4 = c4_scene.instantiate()
	var level: Level = get_tree().get_first_node_in_group("level")
	var player: Player = get_tree().get_first_node_in_group("Player")
	level.main_tilemap_layer.add_child(new_c4)
	new_c4.global_position = global_position
	player.weapon_inventory.remove_c4()
	player.weapon_backpack.remove_current_weapon()
	queue_free()

func _on_audio_stream_player_finished() -> void:
	spawn_c4()
