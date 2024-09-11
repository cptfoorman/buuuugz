extends State
class_name MovementState

var direction: Vector2
var speed: float
signal IMMOVING

func execute_state():
	IMMOVING.emit()
	var dir = direction.normalized()
	entity.velocity = dir * speed
	entity.move_and_slide()
	entity.moving = true
func stop_state():
	entity.moving = false
	
	
	
