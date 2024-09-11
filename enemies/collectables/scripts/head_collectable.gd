extends Area2D
class_name CollectableHead


@export var anim_player: AnimationPlayer


var player : Player = null


enum Heads {MANTIS, HUNDRED, REDMANTIS, CHROBUS}
@export var headtype: Heads


func add_coin():
	match headtype:
		Heads.MANTIS:
			GlobalCurrency.mantis_heads_current += 1
		Heads.HUNDRED:
			GlobalCurrency.hundred_heads_current += 1
		Heads.REDMANTIS:
			GlobalCurrency.mantis_red_heads_current += 1
		Heads.CHROBUS:
			GlobalCurrency.chrobus_heads_current += 1
			


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		anim_player.play("head_collected")
