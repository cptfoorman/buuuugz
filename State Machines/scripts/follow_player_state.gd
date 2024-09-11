extends NavigationState
class_name FollowPlayer


signal FOLLOWPLAYER

func execute_state():
	FOLLOWPLAYER.emit()
	
func stop_state():
	pass
	
