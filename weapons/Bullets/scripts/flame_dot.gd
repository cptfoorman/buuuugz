extends GPUParticles2D

var entity: Node2D

func _ready() -> void:
	entity = get_parent()
	
	
func _process(delta: float) -> void:
	if entity is BaseEnemy:
		entity.health.health -= 1*delta
		global_position = entity.global_position
	else:
		pass
		
