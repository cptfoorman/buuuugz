extends Node
class_name HealthComponent
###reusable health component
@export var max_health: float
@export var health: float
@export var entity: Node2D
@export var low_health_flag: float#flag for when low hp is emited
@export var player_health: bool = false#flag for player i frames still WIP
var can_take_damage: bool = true#eventually for i frames on doges and such but still WIP

var low_hp_emited: bool = false#flag to stop the signal to emit 10x times in a row
signal IDIED
signal LOWHP

func deal_with_healing(heal: float):#eventualy for healing
	health += heal

func deal_with_damage(damage: float):
	health -= damage
	
func _physics_process(delta: float) -> void:
	death()
	low_hp()
func death():#signals something is dead
	if health <= 0:
		health = 0
		IDIED.emit()
func low_hp():#signals siomething is low hp e.g.to activate fleeing state for enemies
	if health <= low_health_flag:
		if low_hp_emited == false:
			LOWHP.emit()
			low_hp_emited = true
func on_hitbox_hit(damage):
	deal_with_damage(damage)


func _on_hitbox_component_igothit(damage) -> void:#takes in the hitbox signal when hurtbox passes through 
	if can_take_damage:
		on_hitbox_hit(damage)
		if player_health == true:
			can_take_damage = false
			await get_tree().create_timer(0.2)
			can_take_damage = true
