extends Node2D
class_name BugEggs
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_health_component_idied() -> void:
	GlobalDifficulty.eggs_destroyed_current+= 3
	GlobalCurrency.score += 150
	audio_stream_player.play()
	self.queue_free()


func _on_audio_stream_player_finished() -> void:
	pass
	
	
