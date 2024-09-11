extends BaseEnemy
class_name Mantis
####basic enemy just attacks at close range


@onready var animation_player: AnimationPlayer = %AnimationPlayer
#############################
##############################
#### state machine related####
enum MovementStatus {MOVING, ATTACKING, SPAWNING, DEATH}
enum NavigationStatus {CHASING, FLEEING}
var navigated:bool = false
@export var movement: MovementStatus = MovementStatus.SPAWNING
@export var navigation: NavigationStatus = NavigationStatus.CHASING
#############################################

func _ready() -> void:
	update_movement_state(MovementStatus.SPAWNING)
	navigation_getter()
	anim_sprite.hide() #sets anim sprite to hide to not draw it ofscreen and reduce lag from stuff of screen
	await get_tree().create_timer(10).timeout
	if on_screen == false:
		queue_free()
	
func _physics_process(delta: float) -> void:
	var marker_pos = nav_marker.global_position
	look_at(marker_pos)#set to look where the marker is going it is kinda buggy and i have to think of something better
	direction = navigator.new_velocity
	match movement:
		MovementStatus.MOVING:
			moving()
		MovementStatus.ATTACKING:
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
		
func navigation_getter():#refreshes the navigation querry
	nav_refresh.wait_time = randf_range(0.5,2)
	nav_refresh.start()
	
func _on_timer_timeout() -> void:#nav refresh
	nav_refresh.stop()
	navigator.get_next_path_position()
	nav_refresh.start()
############################################
##movement
func update_movement_state(new_state):
	movement = new_state
func spawning():#plays animation and sets the state to moving on animation finished
	animation_player.play("spawn")
	await animation_player.animation_finished
	update_movement_state(MovementStatus.MOVING)#doesent update the navigation as the nav refresh is already running
func moving():#sets the entity moving acording to the navigator path given
	current_speed = speed
	direction = navigator.new_velocity
	velocity = direction * current_speed
	move_and_slide()
	animation_player.play("walk")
func attacking():#plays attack animation, sets speed to 0 to make the attack avoidable
	current_speed = 0
	animation_player.play("attack")
func death():#plays death animations that delete the mob and give score
	animation_player.play("death")
###########################################

#################################################
###navigation
func update_navigation_state(new_state):
	navigation = new_state
func chasing():#the markers position is on the player
	nav_marker.global_position = player.global_position
func fleeing():#the markers position is set to the mobs spawn location
	dt_coll.disabled = true#disable the detection to not make the enemies detect player for the time fleeing
	nav_marker.global_position = spawner_position
	await nav_marker_update_timer.timeout
	nav_marker_update_timer.stop()#stop the nav marker from updating after update for the spawn pos to reduce lag
	await get_tree().create_timer(3).timeout
	var distance: Vector2 = global_position - nav_marker.global_position
	if distance <= Vector2(50, 50) or Vector2(-50, -50):
		dt_coll.disabled = false#enables the collision to detect player again
		nav_marker_update_timer.start()#start the marker again to unfreeze the navigation
		update_navigation_state(NavigationStatus.CHASING)
#####################################################
func _on_attack_dt_body_entered(body: Node2D) -> void:#detects if player is in range to attack and advances the FSM
	if body is Player:
		player_in_range = true
		update_movement_state(MovementStatus.ATTACKING)
		

func _on_attack_dt_body_exited(body: Node2D) -> void:#if player leaves checks again to be sure and advances the FSM 
	if body is Player:
		player_in_range = false
		call_deferred("dt_coll_refresh")
		if player_in_range == false:
			update_movement_state(MovementStatus.MOVING)


func stop_process():#to instantly freeze enemy for debug reasons and deletion
	set_physics_process(false)
	
func spawn_head():#spawns collectible head
	var new_head = head.instantiate()
	get_parent().add_child(new_head)
	new_head.global_position = global_position

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:#to enable anim sprite once it entered the screen again
	anim_sprite.show()
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:#hides the sprite and activates timer for deletion deletion checks again to not delete mobs that are visible
	anim_sprite.hide()
	on_screen = false
	await get_tree().create_timer(5).timeout
	if on_screen == false:
		queue_free()


func _on_health_component_idied() -> void:#signal from health component to die
	update_movement_state(MovementStatus.DEATH)
	GlobalCurrency.score += score_gain

func _on_health_component_lowhp() -> void:#signal from health component to flee
	update_navigation_state(NavigationStatus.FLEEING)
	


func _on_nav_marker_update_timer_timeout() -> void:#randomized timer to update the player tracking marker for nav to folow
	nav_marker_update_timer.stop()
	nav_marker.global_position = player.global_position
	nav_marker_update_timer.wait_time = randf_range(0.5,1)
	nav_marker_update_timer.start()
func add_itemxp():#gives xp for drone/shield upgrades
	GlobalCurrency.itemxp += itemxp_gain
