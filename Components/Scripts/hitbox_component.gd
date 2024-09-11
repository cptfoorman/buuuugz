extends Area2D
class_name HitboxComponent


@export var collision_shape: CollisionShape2D
@export var health_component: HealthComponent
@export var hit_sound: AudioStreamPlayer
@export var pitch_upper: float
@export var pitch_lower: float

signal IGOTHIT



###reusable hitbox for everything that has health it accepts area of hurtbox when it enters
###difference between enemies and players hitboxes are collision masks 
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		var damage = area.damage
		IGOTHIT.emit()
		health_component.deal_with_damage(damage)
		if hit_sound != null:
			hit_sound.pitch_scale = randf_range(pitch_upper, pitch_lower)
			hit_sound.play()


func _on_area_exited(area: Area2D) -> void:
	if area is HurtboxComponent:
		pass
		
