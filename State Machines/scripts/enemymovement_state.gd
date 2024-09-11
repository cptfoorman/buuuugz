extends State
class_name EnemyMovementState


var direction: Vector2
var speed: float
signal IMMOVING

func execute_state():
	IMMOVING.emit()
	var dir = direction.normalized()
	if dir.x !=0 and dir.y!=0:
		speed = speed * 0.7
	else: 
		speed = speed
	entity.velocity = dir * speed
	entity.move_and_slide()
func stop_state():
	entity.velocity = direction*0
