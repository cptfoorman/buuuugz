extends Button
class_name StrategyGiver

@export var strategy: BaseBulletStrategy
@export var player: Player
var upgrade_ui: UpgradeDamageUI

func _ready():
	connect("pressed",_on_pressed)
	player = get_tree().get_first_node_in_group("Player")
			
func _on_pressed():
	player.weapon_backpack.current_weapon.bullet_strategy_array.append(strategy)
	player.weapon_backpack.bullet_strategy_array.append(strategy)
	upgrade_ui.visibility_toggle()
