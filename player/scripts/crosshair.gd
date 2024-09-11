extends Marker2D
class_name Crosshair
@onready var hitmarker: Sprite2D = %Sprite2D2
@onready var down: Sprite2D = %down
@onready var left: Sprite2D = %left
@onready var up: Sprite2D = %up
@onready var right: Sprite2D = %right
var timer_started: bool = false

var base_position_up:= -9.0
func _ready() -> void:
	hitmarker.hide()
	
	
	
func hitmarker_hit():
	hitmarker.show()
	await get_tree().create_timer(0.5).timeout
	hitmarker.hide()
func recoil_giver():
	up.position.y -= 0.4
	down.position.y += 0.4
	left.position.x -= 0.4
	right.position.x += 0.4
	
func _physics_process(delta: float) -> void:
	recoil_reducer(delta)
	
func recoil_reducer(delta):
	if up.position.y < base_position_up:
		up.position.y += 0.03
		down.position.y -= 0.03
		left.position.x += 0.03
		right.position.x -= 0.03
	else:
		pass
		
func reset_recoil():
	up.position.y = -9
	down.position.y = 9
	left.position.x = -9
	right.position.x = 9
