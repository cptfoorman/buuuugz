extends Node2D
class_name WeaponBackpack

var hands: CollisionShape2D = null


var player: Player = null

var current_weapon: BaseWeapon = null
enum WeaponSlot {SLOT1, SLOT2, SLOT3}
var eq_weapon : WeaponSlot
var weapon1: BaseWeapon = null
var weapon2: BaseWeapon = null
var weapon3: BaseWeapon = null
@export var bullet_strategy_array: Array [BaseBulletStrategy] = []

func initialize():
	player = get_tree().get_first_node_in_group("Player")
	hands = player.hands
	
	
func weapon_pickup(item: Item):
	var weapon_scene = item.item_scene.instantiate()
	add_child(weapon_scene)
	if current_weapon == null:
		weapon_scene.reparent(hands)
		weapon_scene.on_character = true
		current_weapon = weapon_scene
		weapon1 = weapon_scene
		eq_weapon = WeaponSlot.SLOT1
		current_weapon.set_weapon_straight()
		current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
		player.weapon_inventory.add_belt_item(item)
	elif current_weapon:
		if weapon2 == null:
			weapon2 = weapon_scene
			player.weapon_inventory.add_belt_item(item)
		elif weapon3 == null:
			weapon3 = weapon_scene
			player.weapon_inventory.add_belt_item(item)
		elif weapon1 and weapon2 and weapon3:
			player.weapon_inventory.add_backpack_item(item)
		
		
func _process(delta: float) -> void:
	weapon_switch()

func weapon_switch():
	var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
	if weapon2:
		if Input.is_action_pressed("slot2"):
			if eq_weapon != WeaponSlot.SLOT2:
				crosshair.reset_recoil()
				if current_weapon != null:
					current_weapon.on_character = false
					current_weapon.reparent(player.weapon_backpack)
					current_weapon.hide()
					weapon2.reparent(hands)
					current_weapon = weapon2
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT2
				elif current_weapon == null:
					weapon2.reparent(hands)
					current_weapon = weapon2
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT2
				#if current_weapon is LightSaber:
					#current_weapon.ignite()
	if weapon1:
		if Input.is_action_pressed("slot1"):
			if eq_weapon != WeaponSlot.SLOT1:
				crosshair.reset_recoil()
				if current_weapon != null:
					current_weapon.on_character = false
					current_weapon.reparent(player.weapon_backpack)
					current_weapon.hide()
					weapon1.reparent(hands)
					current_weapon = weapon1
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT1
				elif current_weapon == null:
					weapon1.reparent(hands)
					current_weapon = weapon1
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT1
				#if current_weapon is LightSaber:
					#current_weapon.ignite()
	if weapon3:
		if Input.is_action_pressed("slot3"):
			if eq_weapon != WeaponSlot.SLOT3:
				crosshair.reset_recoil()
				if current_weapon != null:
					current_weapon.on_character = false
					current_weapon.reparent(player.weapon_backpack)
					current_weapon.hide()
					weapon3.reparent(hands)
					current_weapon = weapon3
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT3
				elif current_weapon == null:
					weapon3.reparent(hands)
					current_weapon = weapon3
					current_weapon.on_character = true
					current_weapon.show()
					current_weapon.set_weapon_straight()
					current_weapon.bullet_strategy_array.append_array(bullet_strategy_array)
					eq_weapon = WeaponSlot.SLOT3
func remove_current_weapon():
	if eq_weapon == WeaponSlot.SLOT1:
		current_weapon = null
		weapon1 = null
	elif eq_weapon == WeaponSlot.SLOT2:
		current_weapon = null
		weapon2 = null
	elif eq_weapon == WeaponSlot.SLOT3:
		current_weapon = null
		weapon3 = null
		
