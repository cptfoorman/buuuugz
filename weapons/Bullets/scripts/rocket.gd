extends BulletBase
class_name Rocket

@export var explosion: GPUParticles2D
@export var explosion_sound: AudioStreamPlayer
@onready var collision_explosion: CollisionShape2D = %CollisionShape2D

signal HIT

func _ready() -> void:
	hurtbox.collision.disabled = true
	camshake.collision.disabled = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		explosion.emitting = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != Player:
		explosion.emitting = true

func process_explosion():
	HIT.emit()
	collision_explosion.disabled = true
	camshake.collision.disabled = false
	sprite.visible = false
	speed = 0
	hurtbox.collision.disabled = false
	await get_tree().create_timer(2).timeout
	queue_free()
