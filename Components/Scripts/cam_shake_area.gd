extends Area2D
class_name CamShakeArea

@export var collision: CollisionShape2D
@export var shake_strenght: float
###reusable camera shake detects the player body and activates a function of their camera node
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.camera.randomstrenght = shake_strenght
		body.camera.apply_cam_shake()
