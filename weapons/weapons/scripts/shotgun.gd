extends BaseWeapon
class_name Shotgun

@export var cockback: AudioStreamPlayer
@export var camshake: CamShakeArea
@export var pitch_upper: float
@export var pitch_lower: float
@onready var reloading: Label = %Label
@onready var pielothandright: Sprite2D = %Pielothandright
@onready var pielothand: Sprite2D = %Pielothand
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	pielothandright.hide()
	pielothand.hide()
	reloading.hide()
	camshake.collision.disabled = true
	current_ammo = max_ammo
	mag_bar.max_value = max_ammo
	mag_bar.value = current_ammo

func _unhandled_input(event: InputEvent) -> void:
	if on_character:
		if Input.is_action_just_released("reload"):
			if current_ammo != max_ammo:
				mag_bar.value = 0
				current_ammo = 0
				reloading.show()
				animation_player.play("reload")
				await animation_player.animation_finished
				if on_character:
					reload()
					var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
					crosshair.reset_recoil()
					mag_bar.value = current_ammo
					reloading.hide()
				
func _process(delta: float) -> void:
	if on_character:
		mag_bar.show()
		pielothand.show()
		pielothandright.show()
	else:
		reload_sound.stop()
		reloading.hide()
		pielothand.hide()
		pielothandright.hide()
		mag_bar.hide()
func shoot():
		animation_player.play("pump")
		var new_bullet: BulletBase = bullet.instantiate()
		new_bullet.speed = bullet_speed
		new_bullet.hurtbox.damage = bullet_damage
		new_bullet.global_position = bullet_spawn_marker.global_position
		new_bullet.rotation = get_parent().rotation
		get_tree().get_first_node_in_group("level").add_child(new_bullet)
		for strategy in bullet_strategy_array:
			strategy.apply_strategy(new_bullet)
		var new_bullet2: BulletBase = bullet.instantiate()
		new_bullet2.rotation = get_parent().rotation + randf_range(0.3, -0.3)
		new_bullet2.speed = bullet_speed
		new_bullet2.hurtbox.damage = bullet_damage
		new_bullet2.global_position = bullet_spawn_marker.global_position
		get_tree().get_first_node_in_group("level").add_child(new_bullet2)
		for strategy in bullet_strategy_array:
			strategy.apply_strategy(new_bullet2)
		var new_bullet3: BulletBase = bullet.instantiate()
		new_bullet3.rotation = get_parent().rotation + randf_range(-0.1, 0.2)
		new_bullet3.speed = bullet_speed
		new_bullet3.hurtbox.damage = bullet_damage
		new_bullet3.global_position = bullet_spawn_marker.global_position
		get_tree().get_first_node_in_group("level").add_child(new_bullet3)
		for strategy in bullet_strategy_array:
			strategy.apply_strategy(new_bullet3)
		shot_sound.pitch_scale = randf_range(pitch_lower, pitch_upper)
		var new_bullet4: BulletBase = bullet.instantiate()
		new_bullet4.rotation = get_parent().rotation + randf_range(0.3, -0.3)
		new_bullet4.speed = bullet_speed
		new_bullet4.hurtbox.damage = bullet_damage
		new_bullet4.global_position = bullet_spawn_marker.global_position
		get_tree().get_first_node_in_group("level").add_child(new_bullet4)
		for strategy in bullet_strategy_array:
			strategy.apply_strategy(new_bullet4)
		var new_bullet5: BulletBase = bullet.instantiate()
		new_bullet5.rotation = get_parent().rotation + randf_range(-0.1, 0.2)
		new_bullet5.speed = bullet_speed
		new_bullet5.hurtbox.damage = bullet_damage
		new_bullet5.global_position = bullet_spawn_marker.global_position
		get_tree().get_first_node_in_group("level").add_child(new_bullet5)
		for strategy in bullet_strategy_array:
			strategy.apply_strategy(new_bullet5)
		shot_sound.pitch_scale = randf_range(pitch_lower, pitch_upper)
		shot_sound.play()
		shot_timer.start()
		can_shoot = false
		camshake.collision.disabled = false
		muzzle_flash.visible = true
		var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
		for i in 5:
			crosshair.recoil_giver()
		await get_tree().create_timer(0.05).timeout
		muzzle_flash.visible = false
		cockback.play()
		current_ammo -= 1
		mag_bar.value -= 1


func _on_timer_timeout() -> void:
	shot_timer.stop()
	can_shoot = true
	cockback.stop()
	camshake.collision.disabled = true
