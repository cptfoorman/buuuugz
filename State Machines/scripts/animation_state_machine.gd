extends StateMachine
class_name AnimationStateMachine


@export var animated_player: AnimationPlayer
@export var idle_anim_state: AnimationState
@export var walking_anim_state: AnimationState
@export var attacking_anim_state: AnimationState
@export var death_anim_state: AnimationState
@export var dash_anim_state: AnimationState
@export var spawn: AnimationState

func _on_idling_state():
	idle_anim_state.execute_state()
	
func _on_moving_state():
	walking_anim_state.execute_state()



func _on_idle_animplay(animation_name: String) -> void:
	if animated_player.is_playing() == true:
		animated_player.clear_queue()
		animated_player.queue(animation_name)
	else:
		animated_player.play(animation_name)
		print("idling2")


func _on_walking_animplay(animation_name: String) -> void:
	if animated_player.is_playing() == true:
		animated_player.clear_queue()
		animated_player.queue(animation_name)
	else:
		animated_player.play(animation_name)


func _on_attack_state_imattacking() -> void:
	attacking_anim_state.execute_state()
	


func _on_attack_animplay(animation_name: String) -> void:
	if animated_player.is_playing() == true:
		animated_player.clear_queue()
		animated_player.queue(animation_name)
	else:
		animated_player.play(animation_name)


func _on_death_animplay(animation_name: String) -> void:
	if animated_player.is_playing() == true:
		animated_player.clear_queue()
		animated_player.queue(animation_name)
	else:
		animated_player.play(animation_name)


func _on_health_component_idied() -> void:
	death_anim_state.execute_state()


func _on_dash_state_imdashing() -> void:
	dash_anim_state.execute_state()


func _on_dash_animplay(animation_name: String) -> void:
	animated_player.play(animation_name)


func _on_spawn_animplay(animation_name: String) -> void:
	animated_player.play(animation_name)
