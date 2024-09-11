extends BaseBulletStrategy
class_name PiercingBulletStrategy


@export var piercing_buff: int


func apply_upgrade(bullet: BulletBase):
	bullet.piercing_counter += 1
	
