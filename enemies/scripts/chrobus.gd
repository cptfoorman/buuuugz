extends BaseEnemy
class_name Chrobus

@onready var animation_player: AnimationPlayer = %AnimationPlayer

enum MovementStatus {MOVING,WINDINGUP, ATTACKING, SPAWNING, DEATH}
enum NavigationStatus {CHASING,DASHING, FLEEING}

@export var movement: MovementStatus = MovementStatus.SPAWNING
@export var navigation: NavigationStatus = NavigationStatus.CHASING
var player_dash_direction: Vector2
@export var dash_speed: float


func _ready() -> void:
	update_movement_state(MovementStatus.SPAWNING)
	navigation_getter()



func _physics_process(delta: float) -> void:
	var marker_pos = nav_marker.global_position
	

	direction = navigator.new_velocity
	match movement:
		MovementStatus.MOVING:
			moving()
			look_at(marker_pos)
		MovementStatus.ATTACKING:
			attack()
		MovementStatus.SPAWNING:
			spawn()
		MovementStatus.DEATH:
			death()
		MovementStatus.WINDINGUP:
			winding_up()
	match navigation:
		NavigationStatus.CHASING:
			chasing()
		NavigationStatus.FLEEING:
			fleeing()
		NavigationStatus.DASHING:
			dashing()

func delayed_look_at():
	var marker_pos = nav_marker.global_position
	look_at(marker_pos)

func navigation_getter():
	nav_refresh.wait_time = randf_range(0.5,2)
	nav_refresh.start()
func _on_timer_timeout() -> void:
	nav_refresh.stop()
	navigator.get_next_path_position()
	nav_refresh.start()


#####################################################
##movement
func update_movement_state(new_state):
	movement = new_state
func moving():
	current_speed = speed
	direction = navigator.new_velocity
	velocity = direction * current_speed
	move_and_slide()
	animation_player.play("walk")
func winding_up():
	current_speed = 0
	animation_player.play("windingup")
	await animation_player.animation_finished
	update_movement_state(MovementStatus.ATTACKING)
func attack():
	current_speed = dash_speed
	velocity = direction * current_speed
	move_and_slide()
	animation_player.play("attack")
	await animation_player.animation_finished
	update_navigation_state(NavigationStatus.FLEEING)
	update_movement_state(MovementStatus.MOVING)
func death():
	animation_player.play("death")
func spawn():
	animation_player.play("spawn")
	await animation_player.animation_finished
	update_movement_state(MovementStatus.MOVING)
################################################################
##################################################################
#####navigation
func update_navigation_state(new_state):
	navigation = new_state
func chasing():
	nav_marker.global_position = player.global_position
func fleeing():
	dt_coll.disabled = true
	nav_marker.global_position = spawner_position
	await get_tree().create_timer(2).timeout
	dt_coll.disabled = false
	update_navigation_state(NavigationStatus.CHASING)
		
func dashing():
	nav_marker.global_position = player_dash_direction
		
##############################################################


func stop_process():
	set_physics_process(false)


func spawn_head():
	var new_head = head.instantiate()
	get_parent().add_child(new_head)
	new_head.global_position = global_position

func _on_attack_dt_body_entered(body: Node2D) -> void:
	if body is Player:
		look_at(body.global_position)
		player_dash_direction = body.global_position
		player_in_range = true
		update_movement_state(MovementStatus.WINDINGUP)
		update_navigation_state(NavigationStatus.DASHING)
		navigator._on_timer_timeout()


func _on_attack_dt_body_exited(body: Node2D) -> void:
	if body is Player:
		await animation_player.animation_finished
		player_in_range = false
		update_movement_state(MovementStatus.MOVING)



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	anim_sprite.show()
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	anim_sprite.hide()
	on_screen = false
	await get_tree().create_timer(3).timeout
	if on_screen == false:
		queue_free()


func _on_health_component_idied() -> void:
	update_movement_state(MovementStatus.DEATH)
	GlobalCurrency.score += score_gain


func _on_health_component_lowhp() -> void:
	update_navigation_state(NavigationStatus.FLEEING)
	


func _on_hitbox_component_igothit() -> void:
	current_speed= current_speed/1.5
func add_itemxp():
	GlobalCurrency.itemxp += itemxp_gain
