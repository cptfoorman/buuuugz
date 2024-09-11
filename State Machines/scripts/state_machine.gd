extends Node
class_name StateMachine

@export var start_state: State

var current_state: State
var state_running: bool = false

func initialize():
	for child in get_children():
		if child is State:
			child.entity = self.get_parent()
	current_state = start_state
	state_running = true
func state_processing():
	current_state.execute_state()
	
func update_state(new_state: State):
	if current_state!= null:
		current_state.stop_state()
		current_state = new_state
	if current_state == null:
		current_state = new_state
	state_processing()

func stop_state_process():
	if current_state!= null:
		current_state.stop_state()
	


func _on_state_newstate(state) -> void:
	update_state(state)
	
