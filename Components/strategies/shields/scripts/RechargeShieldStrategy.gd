extends BaseShieldStrategy
class_name RechargehShieldStrategy


@export var recharge_down_by: float

func apply_strategy(shield: BaseShield):
	shield.shield_recharge_time.wait_time -= recharge_down_by
	
	
