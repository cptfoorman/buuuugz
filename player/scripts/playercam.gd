extends Camera2D
class_name PlayerCamera

@export var randomstrenght: float
@export var shakefade: float = 3.0
var shake_strenght: float = 0.0

var rng:= RandomNumberGenerator.new()


func apply_cam_shake():
	shake_strenght = randomstrenght
	print("shakin")
	
	
func random_offset()->Vector2:
	return Vector2(rng.randf_range(-shake_strenght, shake_strenght),rng.randf_range(-shake_strenght, shake_strenght))

func _process(delta: float) -> void:
	if shake_strenght >0:
		shake_strenght = lerpf(shake_strenght,0,shakefade *delta)
		offset = random_offset()
