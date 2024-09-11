extends StateMachine
class_name NavMachine

@export_group("navigation")
@export var navagent: NavComponent
@export var nav_refresh: Timer
@export var nav_marker: Marker2D
@export var nav_to_player: NavigationState




func _on_follow_player_followplayer() -> void:
	nav_marker.global_position = navagent.entity.global_position
	navagent.entity.marker.global_position = navagent.entity.player.global_position
	nav_refresh.start()


func _on_timer_timeout() -> void:
	nav_refresh.stop()
	navagent.get_next_path_position()
