extends Area2D
class_name BulletBase

@export var sprite: Sprite2D
@export var speed: float
@export var hurtbox: HurtboxComponent
@export var despawner: VisibleOnScreenEnabler2D
@export var camshake: CamShakeArea
@export var piercing_counter: int = 0

var on_screen: bool = true
@export var is_explosive: bool = false


func _ready() -> void:
	pass
	

func _physics_process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
		crosshair.hitmarker_hit()
		if camshake!= null:
			call_deferred("coll_cam_deffer")
		if piercing_counter ==0:
			if is_explosive == false:
				queue_free()
			else:
				call_deferred("process_explosion")
		else:
			piercing_counter -= 0
func process_explosion():
	pass


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		var crosshair: Crosshair = get_tree().get_first_node_in_group("PlayerCrosshair")
		crosshair.hitmarker_hit()
	if camshake!= null:
		call_deferred("coll_cam_deffer")
	if is_explosive == false:
		queue_free()
	else:
		call_deferred("process_explosion")
func coll_cam_deffer():
	camshake.collision.disabled = false
