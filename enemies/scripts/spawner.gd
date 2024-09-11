extends Node2D
class_name Spawner


@export var entity_to_spawn: PackedScene
@export var spawn_timer: Timer#spawn timeout
@export var anim_player: AnimationPlayer
@export var sprite: Sprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var destroyed: bool = false#


var timer_counting: bool = false
var player_in_range: bool = false

	
	

func _physics_process(delta: float) -> void:
	if player_in_range == true:
		if timer_counting == false:
			spawn_timer.start()
			timer_counting = true
			print("start")


func _on_timer_timeout() -> void:
	spawn_timer.stop()
	var new_enemy: BaseEnemy = entity_to_spawn.instantiate()
	add_sibling(new_enemy)
	new_enemy.global_position = global_position
	new_enemy.spawner_position = self.global_position
	spawn_timer.start()
	timer_counting = true

func stop_timer():
	spawn_timer.stop()
	timer_counting = true

	
func count_hole_destroyed():
	GlobalDifficulty.holes_destroyed_current += 1

func _on_health_component_idied() -> void:
	stop_timer()
	destroyed = true
	anim_player.play("colapse")
	GlobalCurrency.score += 100
	
	


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	print("u should see me")
	sprite.show()
	timer_counting = false


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	print("vanished")
	sprite.hide()
	stop_timer()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		print("isee player")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		spawn_timer.stop()
		timer_counting = false
