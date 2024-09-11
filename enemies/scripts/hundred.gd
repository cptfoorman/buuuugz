extends BaseEnemy
class_name Hundred
##########STILL WIP RANGED ENEMY
@onready var animation_player: AnimationPlayer = %AnimationPlayer

enum MovementStatus {MOVING, SHOOTING, SPAWNING, DEATH}
enum NavigationStatus {CHASING, FLEEING}

@export var movement: MovementStatus = MovementStatus.SPAWNING
@export var navigation: NavigationStatus = NavigationStatus.CHASING


func _ready() -> void:
	update_movement_state(MovementStatus.SPAWNING)
	navigation_getter()

	
func _physics_process(delta: float) -> void:
	var marker_pos = nav_marker.global_position
	look_at(marker_pos)
	direction = navigator.new_velocity
	match movement:
		MovementStatus.MOVING:
			moving()
		MovementStatus.SHOOTING:
			attacking()
		MovementStatus.SPAWNING:
			spawning()
		MovementStatus.DEATH:
			death()
	match navigation:
		NavigationStatus.CHASING:
			chasing()
		NavigationStatus.FLEEING:
			fleeing()
	#if player_in_range == false:
	#	movement_state_machine.update_state(movement_state_machine.walking)
	#	movement_state_machine.walking.direction = direction
	#	current_speed = speed
	#	movement_state_machine.walking.speed = current_speed
		
func navigation_getter():
	nav_refresh.wait_time = randf_range(0.5,2)
	nav_refresh.start()
	
func _on_timer_timeout() -> void:
	nav_refresh.stop()
	navigator.get_next_path_position()
	nav_refresh.start()
############################################
##movement
func update_movement_state(new_state):
	movement = new_state
func spawning():
	animation_player.play("spawn")
	await animation_player.animation_finished
	update_movement_state(MovementStatus.MOVING)
func moving():
	direction = navigator.new_velocity
	velocity = direction * current_speed
	move_and_slide()
	animation_player.play("walk")
func attacking():
	current_speed = 0
	animation_player.play("attack")
func death():
	animation_player.play("death")
###########################################

#################################################
###navigation
func update_navigation_state(new_state):
	navigation = new_state
func chasing():
	nav_marker.global_position = player.global_position
func fleeing():
	dt_coll.disabled = true
	nav_marker.global_position = spawner_position
	await get_tree().create_timer(3).timeout
	var distance: Vector2 = global_position - nav_marker.global_position
	if distance <= Vector2(50, 50) or Vector2(-50, -50):
		dt_coll.disabled = false
		update_navigation_state(NavigationStatus.CHASING)
		
##############################################################
func speed_up():
	current_speed = speed
	
func speed_down():
	current_speed = 0

func _on_attack_dt_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_attack_dt_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
