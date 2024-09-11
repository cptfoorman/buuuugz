extends NavigationAgent2D
class_name NavComponent
##### Navigation component i made to not rewrite all navigation code
##it is set up to follow a marker of the parent entity the markers position is set by the entity itself



@onready var timer: Timer = $Timer#timer for randomizing the navigation querries to reduce lag
@export var entity: CharacterBody2D#entity this operates on
var current_agent_position: Vector2#entitys global pos
var next_path_position: Vector2#entitis next path point
var new_velocity: Vector2#the counted velocity for the entity

func _ready() -> void:
	#timeout to reduce lag from spawning and instantly making a querry for navigation
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	set_physics_process(true)
	timer.start()
	
### honestly i copied this one from a youtube tutorial and remade it for component usage
### most likey badly lol :D
###in the yt tutorial the guy did it as a process function but straight on the character script
###due to lag and some reading decided to make the function querry on a timer down below
#func _physics_process(delta: float) -> void:
	#target_position = entity.nav_marker.global_position
	#current_agent_position = get_parent().global_position#
	#next_path_position = get_next_path_position()
	#new_velocity = current_agent_position.direction_to(next_path_position)
	
	#if is_navigation_finished():
		#return


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func _on_timer_timeout() -> void:
	timer.stop()
	target_position = entity.nav_marker.global_position
	current_agent_position = get_parent().global_position#
	next_path_position = get_next_path_position()
	new_velocity = current_agent_position.direction_to(next_path_position)
	#not that skilled in this duh but as far as i understood it 
	#sets the target position to the entitys nav marker
	#calculates next path
	#creates a navigation querry to follow
	#returns when the navigation querry is finished
	if is_navigation_finished():
		return
	timer.wait_time = randf_range(0.5,1)
	timer.start()
	#time randomizer to ensure querrys are not being made all at once to reduce lag 
