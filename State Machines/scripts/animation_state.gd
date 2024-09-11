extends State
class_name AnimationState

@export var animation_name: String

signal ANIMPLAY

func execute_state():
	ANIMPLAY.emit(animation_name)
	if entity is Player:
		await get_tree().create_timer(0.2).timeout
		if entity.moving == false:
			ANIMPLAY.emit(animation_name)
		
func stop_state():
	pass
	
		
