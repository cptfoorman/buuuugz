extends StateMachine
class_name MovementStateMachine

@export var walking: State
@export var idle: State
@export var attack: State
@export var dash: DashState



func wants_to_dash():
	if dash.can_dash == true:
		dash.execute_state()
	else:
		print("icant")
		
