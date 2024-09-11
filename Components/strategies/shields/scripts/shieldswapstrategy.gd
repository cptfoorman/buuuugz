extends BaseShieldStrategy
class_name ShieldSwapStrategy


@export var shield_scene: PackedScene
@export var shield_type: int


func apply_strategy(shield: BaseShield):
	var new_shield = shield_scene.instantiate()
	shield.add_sibling(new_shield)
	new_shield.global_position = shield.global_position
	shield.queue_free()
	new_shield.initialize()
