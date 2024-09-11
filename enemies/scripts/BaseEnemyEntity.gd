extends BaseEntity
class_name BaseEnemy
### base enemy class has mostly what i need when making any enemy

@export var navigator: NavComponent#navigation agent
@export var attack_hb:HurtboxComponent#main attack hitbox
@export var own_hb:HitboxComponent#its own hitbox
@export var health: HealthComponent#its own health
@export var speed: float
@export var head: PackedScene
@export var nav_marker: Marker2D#marker that the navigator folows
@export var nav_refresh: Timer#refresh for the navigation agent
@export var nav_marker_update_timer: Timer#refresh for the nav marker tracking to reduce lag
@export var dt_coll: CollisionShape2D#player in attack range detection
@export var anim_sprite: AnimatedSprite2D
@onready var player: Player = get_tree().get_first_node_in_group("Player")#player reference for the marker to follow
@export var score_gain: int
var flee_direction_given: bool = false#see if the fleeing direction has been given for mobs that are supposed to flee once
var on_screen: bool = false#check to ensure the enemy entered the screen at least once
var spawner_position: Vector2#spawner position for fleeing given when the enemy is spawned
var direction: Vector2#direction to be given by the navigator
var player_in_range : bool = false#check to see if player is in attack range
@export var itemxp_gain: int#xp gain for shield/drone upgrade levels


### the coll_refresh function is here for deffered calls when refreshing the detection while flushing querries
func dt_coll_refresh():
	dt_coll.disabled = true
	dt_coll.disabled = false
