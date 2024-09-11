extends State
class_name DashState
var direction: Vector2
var speed: float
var dash_coeficient: float
var dash_time: float
@export var dash_timer: Timer
@export var dash_sound: AudioStreamPlayer
var can_dash: bool = true
signal IMDASHING

func execute_state():
	if can_dash:
		entity.dashing = true
		IMDASHING.emit()
		dash_sound.pitch_scale = randf_range(0.8, 1.2)
		dash_sound.play()
		var new_speed = speed*dash_coeficient
		entity.current_speed = new_speed
		entity.move_and_slide()
		can_dash = false
		dash_timer.start()
		print(new_speed)
func stop_state():
	if entity.dashing == false:
		entity.moving = false
		entity.current_speed = speed
		print("stopped dash")
	else:
		execute_state()
	

	


func _on_timer_timeout() -> void:
	dash_timer.stop()
	entity.current_speed = speed
	can_dash = true
	entity.dashing = false
	print("dash ended")
