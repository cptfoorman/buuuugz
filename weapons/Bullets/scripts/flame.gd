extends BulletBase
class_name BulletFlameParticles


@export var despawn_timer: Timer

func _on_timer_timeout() -> void:
	despawn_timer.stop()
	queue_free()
