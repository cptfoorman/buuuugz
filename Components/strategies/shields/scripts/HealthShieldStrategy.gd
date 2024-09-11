extends BaseShieldStrategy
class_name HealthShieldStrategy


@export var shield_buff: float

func apply_strategy(shield: BaseShield):
	shield.shield_health.max_health += shield_buff
	
