extends BaseBulletStrategy
class_name DamageBulletStrategy

@export var damage_buff: int

func apply_strategy(bullet: BulletBase):
	bullet.hurtbox.damage += damage_buff
