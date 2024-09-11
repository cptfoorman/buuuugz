extends Area2D
class_name DOTGiver

@export var flame_particle_scene : PackedScene
@export var collision: CollisionShape2D
func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		var new_particle_scene: GPUParticles2D = flame_particle_scene.instantiate()
		body.get_parent().add_child(new_particle_scene)
		new_particle_scene.request_ready()
		new_particle_scene.emitting = true
		new_particle_scene.set_as_top_level(true)
		print("sticky")


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var new_particle_scene: GPUParticles2D = flame_particle_scene.instantiate()
		area.add_sibling(new_particle_scene)
		new_particle_scene.request_ready()
		new_particle_scene.emitting = true
		new_particle_scene.set_as_top_level(true)
		new_particle_scene.global_position = area.global_position
		print("sticky")
