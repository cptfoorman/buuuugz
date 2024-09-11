extends Control
class_name ExitUI

signal EXITLEVEL



func _on_yes_pressed() -> void:
	if GlobalDifficulty.exit_open == true:
		EXITLEVEL.emit()
		self.hide()


func _on_no_pressed() -> void:
	self.hide()
