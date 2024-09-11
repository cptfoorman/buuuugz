extends BaseWeapon
class_name Flamethrower


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var firedown: AudioStreamPlayer = %firedown
@onready var reloading: Label = %Label
@onready var backfuel: Sprite2D = %backfuel
@onready var reload_fuel: AnimatedSprite2D = %reload_fuel
@onready var backfuel_2: Sprite2D = %backfuel2
@onready var pielothandright: Sprite2D = %Pielothandright
@onready var pielothand: Sprite2D = %Pielothand
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reloading.hide()
	pielothandright.hide()
	pielothand.hide()
	reload_fuel.hide()
	backfuel.hide()
	backfuel_2.hide()
	current_ammo = max_ammo
	mag_bar.max_value = max_ammo
	mag_bar.value = current_ammo

func _process(delta: float) -> void:
	if on_character == true:
		animated_sprite.play("on")
		mag_bar.show()
		pielothandright.show()
		pielothand.show()
		reload_fuel.show()
		backfuel.show()
		backfuel_2.show()
	else:
		reload_sound.stop()
		animation_player.stop()
		pielothandright.hide()
		pielothand.hide()
		reload_fuel.hide()
		backfuel.hide()
		backfuel_2.hide()
		mag_bar.hide()
func shoot():
	var new_bullet: BulletBase = bullet.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.hurtbox.damage = bullet_damage
	new_bullet.global_position = bullet_spawn_marker.global_position
	new_bullet.rotation = get_parent().rotation
	get_tree().get_first_node_in_group("level").add_child(new_bullet)
	for strategy in bullet_strategy_array:
		strategy.apply_strategy(new_bullet)
	shot_sound.pitch_scale = randf_range(0.8, 1)
	shot_timer.start()
	can_shoot = false
	current_ammo -= 1
	mag_bar.value -= 1
	
func _unhandled_input(event: InputEvent) -> void:
	if on_character:
		if Input.is_action_just_pressed("shoot"):
			firedown.stop()
			shot_sound.play()
		if Input.is_action_just_released("shoot"):
			shot_sound.stop()
			firedown.play()
		if Input.is_action_just_pressed("reload"):
			if current_ammo != max_ammo:
				current_ammo = 0
				mag_bar.value = current_ammo
				reloading.show()
				animation_player.play("reload")
				await animation_player.animation_finished
				if on_character:
					reload()
					reloading.hide()
					mag_bar.value = current_ammo
				
			

func _on_timer_timeout() -> void:
	shot_timer.stop()
	can_shoot = true
