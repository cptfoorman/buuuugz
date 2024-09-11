extends Area2D
class_name HurtboxComponent


@export var damage: float
@export var collision: CollisionShape2D

###reusable hurtbox to collide with hitboxes
### the coll_refresh function is here for deffered calls when trigering the hurtboxes while flushing querries
func coll_refresh():
	collision.disabled = false
	collision.disabled = true
