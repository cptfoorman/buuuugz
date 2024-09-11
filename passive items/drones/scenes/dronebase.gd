extends CharacterBody2D
class_name DroneBase


@export var speed: float
var current_speed: float
var direction: Vector2
@onready var player: Player = get_tree().get_first_node_in_group("Player")
@export var nav_marker: Marker2D
@export var navigator: NavComponent
@export var ofscreen_reset: Timer
@export var visibilitynotifier: VisibleOnScreenNotifier2D
@export var bullet_strategy_array: Array [BaseBulletStrategy] = []
@export var drone_type: int
var on_screen: bool = true
