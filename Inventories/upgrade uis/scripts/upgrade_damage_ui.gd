extends Control
class_name UpgradeDamageUI



var strategy_choice = StrategyGiver
@export var strategy_array : Array[BaseBulletStrategy] = []
var current_strategy_array : Array[BaseBulletStrategy] = []
@export var spawn_count: int
var on_screen = false
@onready var h_box_container: HBoxContainer = %HBoxContainer




func _ready() -> void:
	self.hide()
	get_new_strat_array()
	
func visibility_toggle():
	if on_screen:
		self.hide()
		on_screen = false
		var leftovers = h_box_container.get_children()
		for l in leftovers:
			l.queue_free()
		GlobalDifficulty.unpause()
	else:
		self.show()
		on_screen = true
		get_new_strat_array()
		spawn_counter()
		GlobalDifficulty.pause()
func level_up():
	if GlobalCurrency.xp >= GlobalCurrency.xp_coeficient:
		visibility_toggle()
		GlobalCurrency.xp = 0
func _process(delta: float) -> void:
	level_up()	
func spawn_counter():
	for i in spawn_count:
		spawn_strategy()
		
func spawn_strategy():
	var new_bullet_strategy = current_strategy_array.pick_random()
	current_strategy_array.erase(new_bullet_strategy)
	var new_choice = strategy_choice.new()
	new_choice.upgrade_ui = self
	new_choice.strategy = new_bullet_strategy
	new_choice.text = new_bullet_strategy.strategy_name
	h_box_container.add_child(new_choice)
	
	
func get_new_strat_array():
	for strategy in strategy_array:
		current_strategy_array.append(strategy)
