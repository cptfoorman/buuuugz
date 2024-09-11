extends BaseEntity
class_name Player

@export var speed: float
@export var weapon_backpack: WeaponBackpack
@export var drone_backpack: DroneControl
@export var anim_sprite: AnimatedSprite2D
@export var hands: CollisionShape2D
@export var camera: PlayerCamera
var direction: Vector2
var last_numbered_dir: Vector2

var weapon_inventory: WeaponInventory = WeaponInventory.new()
@onready var currency_ui: Control = %currency_UI
@onready var currency_ui_base: Control = %currency_UI_base
@export var hp_bar: TextureProgressBar
@export var health: HealthComponent
@onready var hpui: Control = %hpui
@onready var hitbox: HitboxComponent = %HitboxComponent

@export var has_dash: bool = false
@export var can_dash: bool = true
@export var dash_speed: float
@export var dash_time_timer: Timer
@export var dash_time_cooldown_timer: Timer
@export var dash_particles: GPUParticles2D
@onready var audio_dash: AudioStreamPlayer = %dash_whosh
@onready var dronehands: CollisionShape2D = %CollisionShape2D
var enemy: BaseEnemy = null
@onready var dronehandsdt_coll: CollisionShape2D = %CollisionShape2D
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@export var shield: BaseShield = null
var dying: bool = false

signal PLAYERDIED

func _ready() -> void:
	current_speed = speed
	weapon_backpack.initialize()
	hp_bar.max_value = health.max_health
	
func _physics_process(delta: float) -> void:
	hp_bar.value = health.health
	direction = Input.get_vector("left", "right","up", "down" )
	velocity = direction * current_speed
	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	marker.global_position = mouse_pos
	anim_sprite.look_at(marker.global_position)
	hands.look_at(mouse_pos)
	animation_handle()
	if enemy:
		dronehands.look_at(enemy.global_position)
	else:
		pass
func _unhandled_input(event: InputEvent) -> void:
	if can_dash == true:
		if has_dash == true:
			if Input.is_action_just_pressed("jump-dash"):
				current_speed = dash_speed
				dash_time_timer.start()
				anim_player.play("dash")
				audio_dash.play()
				can_dash = false
		
func animation_handle():
	if dying == false:
		if velocity != Vector2(0,0):
			anim_player.play("walk")
		else:
			anim_player.play("idle")
		
func switch_ui_to_base():
	currency_ui.hide()
	currency_ui_base.show()
	
func switch_ui_to_mission():
	currency_ui.show()
	currency_ui_base.hide()
func hide_ui_for_shop():
	currency_ui_base.hide()
	hpui.hide()
func show_ui():
	currency_ui_base.show()
	hpui.show()

func player_death():
	PLAYERDIED.emit()
	dying = false

func _on_dash_time_timeout() -> void:
	dash_time_timer.stop()
	current_speed = speed
	dash_time_cooldown_timer.start()
func _on_dash_cooldown_timeout() -> void:
	dash_time_cooldown_timer.stop()
	can_dash = true


func _on_health_component_idied() -> void:
	dying = true
	anim_player.play("death")
	weapon_backpack.bullet_strategy_array.resize(0)


func _on_dronehands_dt_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		enemy = body
		print("THOT DETECTED")


func _on_dronehands_dt_body_exited(body: Node2D) -> void:
	if body is BaseEnemy:
		enemy = null
		call_deferred("dronehands_dt_refresh")

func dronehands_dt_refresh():
	dronehandsdt_coll.disabled = true
	dronehandsdt_coll.disabled = false
