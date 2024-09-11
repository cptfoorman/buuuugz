extends Control
class_name ItemUpgradeMenu

@export var possible_shield_upgrades: Array [BaseShieldStrategy] = []
var current_possible_shield_upgrades: Array [BaseShieldStrategy] = []
@export var possible_shield_swaps: Array [ShieldSwapStrategy] = []
var current_possible_shield_swaps: Array [ShieldSwapStrategy] = []
@export var possible_drone_upgrades: Array [BaseBulletStrategy] = []
var current_possible_drone_upgrades: Array [BaseBulletStrategy] = []
@export var possible_drone_swaps: Array [DroneSwapStrategy] = []
var current_possible_drone_swaps: Array [DroneSwapStrategy] = []

@onready var base_upgrade_choice: PanelContainer = %BaseUpgradeChoice
@onready var shield_upgrades: PanelContainer = %ShieldUpgrades
@onready var drone_upgrades: PanelContainer = %DroneUpgrades
@onready var shieldupgrade: Button = %shieldupgrade
@onready var shieldupgrade_2: Button = %shieldupgrade2
@onready var shieldswapoption: Button = %shieldswapoption
@onready var droneupgrade: Button = %droneupgrade
@onready var droneupgrade_2: Button = %droneupgrade2
@onready var droneswapoption: Button = %droneswapoption

var player: Player = null



var shield_option1: BaseShieldStrategy = null
var shield_option2: BaseShieldStrategy = null
var shield_swap_option: ShieldSwapStrategy = null

var drone_option1: BaseBulletStrategy = null
var drone_option2: BaseBulletStrategy = null
var drone_swap_option: DroneSwapStrategy = null

var player_shield_type: int = 3
var player_drone_type: int = 2

func _on_shields_button_up() -> void:
	base_upgrade_choice.hide()
	shield_upgrades.show()
	generate_shield_upgrades()
	call_deferred("assign_shield_upgrades")
	generate_shield_swap()
	call_deferred("clear_current_shield_from_swap")
	call_deferred("assign_swap")


func _on_drones_button_up() -> void:
	base_upgrade_choice.hide()
	drone_upgrades.show()
	generate_drone_upgrades()
	call_deferred("assign_drone_upgrades")
	generate_drone_swap()
	call_deferred("clear_current_drone_from_swap")
	call_deferred("assign_drone_swap")
	
	
#########################################################
############shields selected#############################
func generate_shield_swap():
	for shield in possible_shield_swaps:
		current_possible_shield_swaps.append(shield)
func clear_current_shield_from_swap():
	for shield in current_possible_shield_swaps:
		if shield.shield_type == player_shield_type:
			current_possible_shield_swaps.erase(shield)
func assign_swap():
	shield_swap_option = current_possible_shield_swaps.pick_random()
func generate_shield_upgrades():
	for strategy in possible_shield_upgrades:
		current_possible_shield_upgrades.append(strategy)
		
func assign_shield_upgrades():
	var new_option1 = current_possible_shield_upgrades.pick_random()
	shield_option1 = new_option1
	current_possible_shield_upgrades.erase(new_option1)
	var new_option2 = current_possible_shield_upgrades.pick_random()
	shield_option2 = new_option2
	current_possible_shield_upgrades.erase(new_option2)
##########################################################################
##########################################################################
########################################################################
##########drones selected#################################################

func generate_drone_upgrades():
	for strategy in possible_drone_upgrades:
		current_possible_drone_upgrades.append(strategy)
func assign_drone_upgrades():
	var new_option1 = current_possible_drone_upgrades.pick_random()
	drone_option1 = new_option1
	current_possible_drone_upgrades.erase(new_option1)
	var new_option2 = current_possible_drone_upgrades.pick_random()
	drone_option2 = new_option2
	current_possible_drone_upgrades.erase(new_option2)
	
func generate_drone_swap():
	for drone in possible_drone_swaps:
		current_possible_drone_swaps.append(drone)
	
func clear_current_drone_from_swap():
	for drone in current_possible_drone_swaps:
		if drone.drone_type == player_drone_type:
			current_possible_drone_swaps.erase(drone)
			
func assign_drone_swap():
	drone_swap_option = current_possible_drone_swaps.pick_random()
			
#############################################################################
#############################################################################
func _process(delta: float) -> void:
	if shield_option1 != null:
		shieldupgrade.text = shield_option1.strategy_name
	if shield_option2 != null:
		shieldupgrade_2.text = shield_option2.strategy_name
	if shield_swap_option != null:
		shieldswapoption.text = shield_swap_option.strategy_name
	if drone_option1 != null:
		droneupgrade.text = drone_option1.strategy_name
	if drone_option2 != null:
		droneupgrade_2.text = drone_option2.strategy_name
	if drone_swap_option != null:
		droneswapoption.text = drone_swap_option.strategy_name
	if GlobalCurrency.itemxp >= GlobalCurrency.itemxp_coeficient:
		open()
		GlobalCurrency.itemxp = 0
		GlobalCurrency.itemxp_coeficient += GlobalCurrency.itemxp_coeficient/2
		GlobalDifficulty.pause()

func _on_droneswapoption_button_up() -> void:
	drone_swap_option.apply_strategy(player.drone_backpack)
	hide()
	GlobalDifficulty.unpause()


func _on_droneupgrade_2_button_down() -> void:
	player.drone_backpack.bullet_strategy_array.append(drone_option2)
	hide()
	GlobalDifficulty.unpause()
	

func _on_droneupgrade_button_up() -> void:
	player.drone_backpack.bullet_strategy_array.append(drone_option1)
	hide()
	GlobalDifficulty.unpause()


func _on_shieldswapoption_button_up() -> void:
	shield_swap_option.apply_strategy(player.shield)
	hide()
	GlobalDifficulty.unpause()


func _on_shieldupgrade_2_button_up() -> void:
	shield_option2.apply_strategy(player.shield)
	hide()
	GlobalDifficulty.unpause()
	
	
func _on_shieldupgrade_button_up() -> void:
	shield_option1.apply_strategy(player.shield)
	hide()
	GlobalDifficulty.unpause()


func open():
	show()
	var current_player: Player = get_tree().get_first_node_in_group("Player")
	player = current_player
	shield_upgrades.hide()
	drone_upgrades.hide()
	base_upgrade_choice.show()
	player_drone_type = player.drone_backpack.current_drone_type
	player_shield_type = player.shield.shield_type_number
