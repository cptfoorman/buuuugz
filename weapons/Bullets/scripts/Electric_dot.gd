extends GPUParticles2D


var entity: Node2D
@export var slow_timer: Timer


func _ready() -> void:
	entity = get_parent()
	slow_timer.start()
	
func _process(delta: float) -> void:
	if entity is BaseEnemy:
		entity.health.health -= 0.3*delta
		global_position = entity.global_position
	else:
		pass
		


func _on_timer_timeout() -> void:
	slow_timer.stop()
	if entity is BaseEnemy:
		entity.speed -= 5
	slow_timer.start()
