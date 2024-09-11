extends DroneBase
class_name AssaulutDrune


var target_enemy: BaseEnemy = null
@export var bullet: PackedScene
@export var shot_timer: Timer
var can_shoot: bool = true
var on_character: bool = true
@onready var hands: CollisionShape2D = $hands
@onready var dt_coll: CollisionShape2D = %CollisionShape2D

@export var bullet_speed: float
@export var bullet_damage: float
@export var bullet_spawn_marker: Marker2D
@export var shot_marker: Marker2D
@onready var shot_sound: AudioStreamPlayer = %AudioStreamPlayer
@onready var muzzleflash: Sprite2D = %muzzleflash
@onready var drone_flight: AudioStreamPlayer2D = %AudioStreamPlayer2D



func _ready() -> void:
	current_speed = speed
	muzzleflash.hide()
	drone_flight.play()
	
	
func _physics_process(delta: float) -> void:
	nav_marker.global_position = player.drone_backpack.drone_marker.global_position
	if target_enemy:
		shot_marker.global_position = target_enemy.global_position
		hands.look_at(shot_marker.global_position)
		bullet_spawn_marker.look_at(target_enemy.global_position)
		if can_shoot:
			shoot()
	else:
		shot_marker.global_position = global_position
		hands.look_at(player.marker.global_position)
		direction = navigator.new_velocity
		velocity = direction * speed
		move_and_slide()
		
		
		
func shoot():
	print("droneshooting")
	var new_bullet: BulletBase = bullet.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.hurtbox.damage = bullet_damage
	new_bullet.global_position = bullet_spawn_marker.global_position
	new_bullet.rotation = hands.rotation
	get_tree().get_first_node_in_group("level").add_child(new_bullet)
	for strategy in bullet_strategy_array:
		strategy.apply_strategy(new_bullet)
	can_shoot = false
	shot_timer.start()
	shot_sound.play()
	muzzleflash.show()
	await get_tree().create_timer(0.1).timeout
	muzzleflash.hide()
func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		print("thotdetected")
		if target_enemy == null:
			target_enemy = body
			


func _on_shot_timer_timeout() -> void:
	shot_timer.stop()
	can_shoot = true
	call_deferred("dt_coll_refresh")


func _on_enemy_detection_body_exited(body: Node2D) -> void:
	if body is BaseEnemy:
		target_enemy = null


func dt_coll_refresh():
	dt_coll.disabled = true
	dt_coll.disabled = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
	ofscreen_reset.start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true
	ofscreen_reset.stop()


func _on_timer_timeout() -> void:
	ofscreen_reset.stop()
	if on_screen == false:
		global_position = nav_marker.global_position
