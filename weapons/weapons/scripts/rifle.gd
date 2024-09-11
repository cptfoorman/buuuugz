extends BaseWeapon
class_name Rifle
@export var cam_shake: CamShakeArea
var recoil_degrees: float = 0.0
@export var recoil_top : float
@export var recoil_timer: Timer
@export var recoil_str: float
@onready var reloading: Label = %Label
@onready var pielothand: Sprite2D = %Pielothand
@onready var pielothandright: Sprite2D = %Pielothandright
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	reloading.hide()
	cam_shake.collision.disabled = true
	current_ammo = max_ammo
	mag_bar.max_value = max_ammo
	mag_bar.value = current_ammo

func _unhandled_input(event: InputEvent) -> void:
	if on_character:
		if Input.is_action_just_pressed("reload"):
			if current_ammo != max_ammo:
				mag_bar.value = 0
				current_ammo = 0
				reloading.show()
				animation_player.play("reload")
				await  get_tree().create_timer(reload_time).timeout
				if on_character:
					reload()
					var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
					crosshair.reset_recoil()
					recoil_degrees = 0
					mag_bar.value = current_ammo
					reloading.hide()
func _process(delta: float) -> void:
	if recoil_degrees >= recoil_top:
		recoil_degrees = recoil_top
	if on_character:
		mag_bar.show()
		pielothand.show()
		pielothandright.show()
	else:
		reload_sound.stop()
		animation_player.stop()
		reloading.hide()
		pielothand.hide()
		pielothandright.hide()
		mag_bar.hide()
func shoot():
	var new_bullet: BulletBase = bullet.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.hurtbox.damage = bullet_damage
	new_bullet.global_position = bullet_spawn_marker.global_position
	new_bullet.rotation = get_parent().rotation
	new_bullet.rotation += randf_range(recoil_degrees, -recoil_degrees)
	get_tree().get_first_node_in_group("level").add_child(new_bullet)
	for strategy in bullet_strategy_array:
		strategy.apply_strategy(new_bullet)
	shot_sound.pitch_scale = randf_range(0.8, 1)
	shot_sound.play()
	shot_timer.start()
	can_shoot = false
	cam_shake.collision.disabled = false
	recoil_degrees += recoil_str
	muzzle_flash.visible = true
	var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
	crosshair.recoil_giver()
	await get_tree().create_timer(0.05).timeout
	muzzle_flash.visible = false
	current_ammo -= 1
	mag_bar.value -= 1
	recoil_timer.start()


func _on_timer_timeout() -> void:
	shot_timer.stop()
	can_shoot = true
	cam_shake.collision.disabled = true


func _on_timer_2_timeout() -> void:
	recoil_timer.stop()
	recoil_degrees = 0.0
