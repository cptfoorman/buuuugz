extends Node2D
class_name BaseShield


@export var on_character: bool = false
@export var shield_health : HealthComponent
@export var shield_hb: HitboxComponent
@export var entity: Player = null
enum ShieldHP {DEPLETED, NOTDEPLETED}
@export var ShieldHPStatus : ShieldHP
@export var shield_recharge_time: Timer
@export var animated_sprite: AnimatedSprite2D
@onready var hpui: Control = %hpui
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@export var shield_type_number: int
func _ready() -> void:
	texture_progress_bar.max_value = shield_health.max_health
	hpui.hide()
	animated_sprite.hide()
func initialize():
	entity = get_parent()
	on_character = true
	entity.shield = self
func _physics_process(delta: float) -> void:
	if entity != null:
		if on_character:
			match ShieldHPStatus:
				ShieldHP.DEPLETED:
					depleted()
				ShieldHP.NOTDEPLETED:
					full()
			hpui.show()
			texture_progress_bar.value = shield_health.health
func update_state(new_state):
	ShieldHPStatus = new_state
	
func full():
	if shield_health.health >0:
		entity.hitbox.collision_shape.disabled = true
		shield_hb.collision_shape.disabled = false
		animated_sprite.show()
	else:
		shield_recharge_time.start()
		update_state(ShieldHP.DEPLETED)

func depleted():
	if shield_health.health == 0:
		entity.hitbox.collision_shape.disabled = false
		shield_hb.collision_shape.disabled = true
		animated_sprite.hide()
	else:
		update_state(ShieldHP.NOTDEPLETED)
		

func reset_shield():
	shield_health.health = shield_health.max_health

func _on_timer_timeout() -> void:
	shield_recharge_time.stop()
	reset_shield()
	update_state(ShieldHP.NOTDEPLETED)
