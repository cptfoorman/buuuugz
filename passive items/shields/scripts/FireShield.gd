extends BaseShield
class_name AttackShield


@export var dot_giver: DOTGiver

func _ready() -> void:
	dot_giver.collision.disabled = true

func _on_hitbox_component_igothit() -> void:
	call_deferred("coll_defered")

func coll_defered():
	dot_giver.collision.disabled = false
	await get_tree().create_timer(0.1).timeout
	dot_giver.collision.disabled = true
