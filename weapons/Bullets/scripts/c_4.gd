extends Node2D
class_name C4


@export var countdown_timer1: Timer
@export var countdown_timer2: Timer
@export var hurtbox: HurtboxComponent
@export var particles: GPUParticles2D
@export var bomb_beep: AudioStreamPlayer
@export var bomb_beep_aggro: AudioStreamPlayer
@export var bomb_explosion: AudioStreamPlayer
@export var sprite: Sprite2D
@export var cam_shake: CamShakeArea

func _ready() -> void:
	countdown_timer1.start()
	bomb_beep.play()
	hurtbox.collision.disabled = true
	cam_shake.collision.disabled = true


func _on_timer_timeout() -> void:
	countdown_timer1.stop()
	bomb_beep.stop()
	bomb_beep_aggro.play()
	countdown_timer2.start()


func _on_timer_2_timeout() -> void:
	countdown_timer2.stop()
	bomb_beep_aggro.stop()
	bomb_explosion.play()
	particles.emitting = true
	sprite.visible = false
	hurtbox.collision.disabled = false
	cam_shake.collision.disabled = false
	await get_tree().create_timer(0.1).timeout
	hurtbox.collision.disabled = true
	cam_shake.collision.disabled = true
	await get_tree().create_timer(3).timeout
	queue_free()
