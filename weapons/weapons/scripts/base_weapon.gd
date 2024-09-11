extends Node2D
class_name BaseWeapon

@export_group("Bullet control")
@export var shot_timer: Timer
@export var bullet: PackedScene
@export var bullet_speed: float
@export var bullet_damage: float
@export var shot_sound: AudioStreamPlayer
@export var bullet_spawn_marker: Marker2D
@export var max_ammo: int
@export var mag_bar: TextureProgressBar
@export var reload_time: float
@export var reload_sound: AudioStreamPlayer
var current_ammo: int
var bullet_strategy_array: Array [BaseBulletStrategy] = []

@export_group("Visual")
@export var sprite: Sprite2D
@export var muzzle_flash: Sprite2D
@export var reload_icon: Sprite2D

@export_group("On_person_Mellee and scope checks")
@export var scoped_weapon: bool = false
@export var melee_weapon: bool = false
@export var on_character: bool = false
@export var can_shoot: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if on_character:
		if can_shoot:
			if current_ammo >= 1:
				if Input.is_action_pressed("shoot"):
					shoot()

func shoot():
	pass
	
func set_weapon_straight():
	rotation = 0
	self.global_position = get_parent().global_position
	bullet_strategy_array.resize(0)
	

func reload():
	current_ammo = max_ammo
	mag_bar.value = current_ammo
