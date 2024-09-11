extends Area2D
class_name EffectOnHitGiver


@export var particles: GPUParticles2D
@export var hurtbox: HurtboxComponent
@export var collision: CollisionShape2D
var current_particles: GPUParticles2D


func _ready() -> void:
	particles.emitting = false
	hurtbox.collision.disabled = true
	var parent: BulletBase = get_parent()
	hurtbox.damage = parent.hurtbox.damage
	

func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		current_particles.emitting = true
		hurtbox.collision.disabled = false
		await get_tree().create_timer(0.3).timeout
		hurtbox.collision.disabled = true
		await current_particles.finished
		queue_free()
		

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		current_particles.emitting = true
		hurtbox.collision.disabled = false
		await get_tree().create_timer(0.3).timeout
		hurtbox.collision.disabled = true
		await current_particles.finished
		queue_free()
