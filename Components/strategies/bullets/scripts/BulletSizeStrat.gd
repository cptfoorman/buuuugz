extends BaseBulletStrategy
class_name SizeBulletStrategy


@export var size_buff: float

var size_buff_vector:= Vector2(size_buff, size_buff)


func apply_strategy(bullet: BulletBase):
	bullet.scale += size_buff_vector
	bullet.camshake.shake_strenght += size_buff
