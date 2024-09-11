extends State
class_name AttackState


@export var stationary_attack: bool

var direction: Vector2
var speed: float
signal IMATTACKING

func execute_state():
	IMATTACKING.emit()
	if stationary_attack == false:
		var dir = direction.normalized()
		if dir.x !=0 and dir.y!=0:
			speed = speed * 0.7
		else: 
			speed = speed
		entity.velocity = dir * speed
		entity.move_and_slide()
	else:
		entity.velocity = direction * 0
func stop_state():
	entity.velocity = direction * 0
