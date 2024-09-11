extends BaseWeapon
class_name Bazooka

@export var cam_shake: CamShakeArea
@export var rocket: Sprite2D
@export var rocket_explosion: AudioStreamPlayer
@onready var reloading: Label = %Label
@onready var rocket_3: Sprite2D = $Rocket3
@onready var reloadrocket: Sprite2D = $reloadrocket
@onready var rocket_2: Sprite2D = $Rocket2
@onready var pielothand: Sprite2D = %Pielothand
@onready var pielothandright: Sprite2D = %Pielothandright
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	rocket_3.hide()
	reloadrocket.hide()
	rocket_2.hide()
	reloading.hide()
	pielothandright.hide()
	pielothand.hide()
	cam_shake.collision.disabled = true
	current_ammo = max_ammo
	mag_bar.max_value = max_ammo
	mag_bar.value = current_ammo

func _unhandled_input(event: InputEvent) -> void:
	if on_character:
		if Input.is_action_just_released("reload"):
			if current_ammo != max_ammo:
				mag_bar.value = 0
				reload_sound.play()
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
					reloadrocket.hide()
					rocket.show()
func _process(delta: float) -> void:
	if on_character:
		mag_bar.show()
		rocket_3.show()
		rocket_2.show()
		pielothand.show()
		pielothandright.show()
	else:
		reload_sound.stop()
		reloading.hide()
		mag_bar.hide()
		rocket_3.hide()
		reloadrocket.hide()
		rocket_2.hide()
		pielothandright.hide()
		pielothand.hide()
func shoot():
	var level: Level = get_tree().get_first_node_in_group("level")
	var new_bullet: Rocket = bullet.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.hurtbox.damage = bullet_damage
	new_bullet.global_position = bullet_spawn_marker.global_position
	new_bullet.rotation = get_parent().rotation
	level.add_child(new_bullet)
	new_bullet.connect("HIT", _on_rocket_hit)
	shot_sound.pitch_scale = randf_range(0.8, 1)
	shot_sound.play()
	shot_timer.start()
	can_shoot = false
	cam_shake.collision.disabled = false
	current_ammo -= 1
	mag_bar.value -= 1
	rocket.hide()
	muzzle_flash.visible = true
	var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
	for i in 10:
		crosshair.recoil_giver()
	await get_tree().create_timer(0.05).timeout
	muzzle_flash.visible = false
	


func _on_timer_timeout() -> void:
	shot_timer.stop()
	can_shoot = true
	cam_shake.collision.disabled = true


func _on_rocket_hit() -> void:
	rocket_explosion.play()
