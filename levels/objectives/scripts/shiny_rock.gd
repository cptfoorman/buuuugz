extends Node2D
class_name ShinyRock




func _on_health_component_idied() -> void:
	GlobalCurrency.xp += 20
	GlobalCurrency.score += 500
	queue_free()
