extends BaseBulletStrategy
class_name SpeedBulletStrategy


@export var speed_buff: float

func apply_strategy(bullet: BulletBase):
	bullet.speed += speed_buff
	
