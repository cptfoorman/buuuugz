extends State
class_name IdleState

signal IMIDLING

func execute_state():
	IMIDLING.emit()
	entity.moving = false
	
