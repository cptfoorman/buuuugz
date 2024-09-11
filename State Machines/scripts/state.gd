extends Node
class_name State

var entity: BaseEntity
var state: State

func _ready() -> void:
	state = self

func execute_state():
	pass
	
func stop_state():
	pass
	
