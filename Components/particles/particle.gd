extends GPUParticles2D

###placeholder reusable bloodparticle that responds to hitbox signals
func _on_hitbox_component_igothit() -> void:
	emitting = true

func on_dash_activated():
	emitting = true
