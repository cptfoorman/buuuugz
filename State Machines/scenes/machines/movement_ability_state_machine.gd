extends StateMachine
class_name MovementAbilityStateMachine


@export var dash_ability: DashState


func wants_to_dash():
	if dash_ability.can_dash == true:
		dash_ability.execute_state()
	else:
		print("icant")
		
		
