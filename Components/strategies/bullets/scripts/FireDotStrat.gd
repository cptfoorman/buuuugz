extends BaseBulletStrategy
class_name DOTGiverBulletStrategy


@export var dot_scene: PackedScene


func apply_strategy(bullet: BulletBase):
	var new_dot_giver = dot_scene.instantiate()
	bullet.add_child(new_dot_giver)
	new_dot_giver.global_position = bullet.global_position
