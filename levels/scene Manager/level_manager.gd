extends Node
class_name SceneManager
#manages scene transitions and adds spawns and spawn enemies dependant on difficulty
#i didnt make this a global since i needed the set export variables since im a noob and dont want to mess with file paths
#and when i load this as a global i loose all the export variables

@export_group("levels")
@export var test1_scene: PackedScene
@export var level_scenes: Array[PackedScene] = []
var next_scene: PackedScene
@export var difficulty_timeout: Timer


@export_group("spawners and enemies")
@export var spawner_scene: PackedScene
@export var mantis_scene: PackedScene
@export var mantis_red_scene: PackedScene
@export var chrobus_scene: PackedScene

@export_group("objectives")
@export var shinyrock: PackedScene #the gun upgrade rock
@export var eggs_objective: PackedScene #for destroying eggs mission
@export var c_poor_objective: PackedScene #for destroying spawners mission
enum Current_Objective {EGGS, CP}
@export var current_objectives: Current_Objective


#temp arrays to ensure im not going over arrays that are already being gone over
var current_enemy_array: Array[PackedScene] = []
var current_marker_array: Array[Marker2D] = []
var current_shiny_rock_marker_array: Array[Marker2D] = []
var current_spawner_array: Array[Spawner] = []

@export_group("VideoAudio")
#for playing audio and fade-ins/outs and global messages
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var soundtrack: AudioStreamPlayer

@export_group("UI")
#for making the ui work with the level transition 
@onready var diff_selector: DiffUI = %diff_selector
@onready var exit_mission_ui: ExitUI = %ExitMissionUI
@onready var spawner_increased_text: TextureRect = $CanvasLayer/TextureRect2

#shield for player death reset
@export var basic_shield: PackedScene

#current player instance and level instance both to be set at runtime
var player: Player = null
var level: Level = null



func _ready() -> void:
	fade_in()
	get_level()
	get_player()
	remove_player()
	add_player()
	fade_out()
	soundtrack.play()
	
	
func _on_player_playerdied() -> void:#calls the on death reload and resets hp
	reset_player_health()
	player_dead_load_base_level()

###########################################################################
########## CURRENCY AND MISSION RESET#####################################
func transfer_currency():
	GlobalCurrency.hundred_heads += GlobalCurrency.hundred_heads_current
	GlobalCurrency.hundred_heads_current = 0
	GlobalCurrency.mantis_heads += GlobalCurrency.mantis_heads_current
	GlobalCurrency.mantis_heads_current = 0
	GlobalCurrency.mantis_red_heads += GlobalCurrency.mantis_red_heads_current
	GlobalCurrency.mantis_red_heads_current = 0
	GlobalCurrency.chrobus_heads += GlobalCurrency.chrobus_heads_current
	GlobalCurrency.chrobus_heads_current = 0
func clear_currency():
	GlobalCurrency.chrobus_heads_current = 0
	GlobalCurrency.hundred_heads_current = 0
	GlobalCurrency.mantis_heads_current = 0
	GlobalCurrency.mantis_red_heads_current = 0
func reset_mission_progress():
	GlobalDifficulty.eggs_destroyed_current = 0
	GlobalDifficulty.holes_destroyed_current = 0
####################################################################################
########### SPAWNING OBJECTIVES AND ENEMIES ########################################
func _on_diff_selector_difficulty_set() -> void:
	load_enemy_level()
	
func _on_exit_mission_ui_exitlevel() -> void:
	load_base_level()
### GETTERS 
func set_objective():#sets the spawn objectives method to have the right objective scenes
	match GlobalDifficulty.objectives:
		GlobalDifficulty.Objective.EGGS:
			current_objectives = Current_Objective.EGGS
		GlobalDifficulty.Objective.CP:
			current_objectives = Current_Objective.CP
func get_current_spawners():#gets current súawners for timout incease
	for child in level.spawner_stash.get_children():
		if child is Spawner:
			current_spawner_array.append(child)
func get_spawn_markers():# gets maekers from the stash in the level instance
	for child in level.marker_stash.get_children():
		current_marker_array.append(child)
func get_shiny_rock_markers():#gets special maekers for the upgrade spawns
	for child in level.shinyrock_stash.get_children():
		current_shiny_rock_marker_array.append(child)
		
func set_next_difficulty_enemies():#sets the new spawn lists for spawners for the current difficulty
	if GlobalDifficulty.difficulty_modifier == 1:
		current_enemy_array.append(mantis_scene)
	elif GlobalDifficulty.difficulty_modifier == 2:
		current_enemy_array.append(mantis_scene)
	elif GlobalDifficulty.difficulty_modifier == 3:
		current_enemy_array.append(mantis_scene)
		current_enemy_array.append(mantis_red_scene)
	elif GlobalDifficulty.difficulty_modifier == 4:
		current_enemy_array.append(mantis_scene)
		current_enemy_array.append(mantis_red_scene)
		current_enemy_array.append(chrobus_scene)

func clear_enemy_array():#resizes the array to 0 for next enemy list iteration
	current_enemy_array.resize(0)

###SPAWNERS
func spawn_objectives():#spawns the levels objectives, happens before the spawners to always have possible completion
	match current_objectives:
		Current_Objective.EGGS:
			for i in 6:
				var marker_point = current_marker_array.pick_random()
				var eggs_scene = eggs_objective.instantiate()
				level.main_tilemap_layer.add_child(eggs_scene)
				eggs_scene.global_position = marker_point.global_position
				current_marker_array.erase(marker_point)
		Current_Objective.CP:
			var c_poor_machine = c_poor_objective.instantiate()
			add_child(c_poor_machine)
			c_poor_machine.reparent(level.main_tilemap_layer)
			c_poor_machine.global_position = level.spawn_point.global_position
			for i in GlobalDifficulty.holes_to_destroy:
				var new_spawner: Spawner=spawner_scene.instantiate()
				var marker_point = current_marker_array.pick_random()
				level.main_tilemap_layer.add_child(new_spawner)
				new_spawner.global_position = marker_point.global_position
				var next_enemy = current_enemy_array.pick_random()
				new_spawner.entity_to_spawn = next_enemy
				current_marker_array.erase(marker_point)

func add_spawners():#adds spawners to level and sets their enemies, reparents to a node for timeout spawn increase
	for i in GlobalDifficulty.bughole_count:
		var new_spawner: Spawner=spawner_scene.instantiate()
		var marker_point = current_marker_array.pick_random()
		level.spawner_stash.add_child(new_spawner)
		new_spawner.global_position = marker_point.global_position
		var next_enemy = current_enemy_array.pick_random()
		new_spawner.entity_to_spawn = next_enemy
		current_marker_array.erase(marker_point)

func add_shiny_rocks():#adds upgrade rocks to the current map
	for i in 6:
		var new_rock = shinyrock.instantiate()
		var new_marker = current_shiny_rock_marker_array.pick_random()
		level.main_tilemap_layer.add_child(new_rock)
		new_rock.global_position = new_marker.global_position
		current_shiny_rock_marker_array.erase(new_marker)


###Spawn increase timeout
func increase_spawns():#function for the spawn increase timeout
	for spawner in current_spawner_array:
		if spawner!= null:
			spawner.collision_shape_2d.scale += Vector2(0.05,0.05)
			spawner.spawn_timer.wait_time -= 0.02
func _on_timer_timeout() -> void:#timeout for spawn increase
	difficulty_timeout.stop()
	print("SPAWNSINCREASED")
	get_current_spawners()
	call_deferred("increase_spawns")
	animation_player.play("spawns_increased")
	level.spawners_increased_shake()
	difficulty_timeout.start()


##############################################################################
#######LEVEL CONTROL###########################################################
func load_main_level():#loads the main level from which you go on missions
	var new_level: Level = test1_scene.instantiate()
	add_child(new_level)
	level = new_level
func load_new_level():#gets the set next scene level 
	var new_level: Level = next_scene.instantiate()
	add_child(new_level)
	level = new_level
func get_level():#gets the current level instance
	level = get_tree().get_first_node_in_group("level")
	#Transitions
func fade_in():
	animation_player.play("fade_in")
func fade_out():
	animation_player.play("fade_out")
	
	
func get_next_enemy_level():#picks next level map
	next_scene = level_scenes.pick_random()
func get_base_level():#sets next level as the base area
	next_scene = test1_scene
func remove_level():#removes current level instance
	remove_child(level)
##################################################################################
#################################################################################
##########################################################################
############# PLAYER CONTROL##############################################
func get_player():#gets current instance of the player
	player = get_tree().get_first_node_in_group("Player")
func remove_player():#removes player for switching levels
	player.reparent(self)

func add_player():#adds player to the scene and ensures if he has a drone its active
	player.reparent(level.main_tilemap_layer)
	player.global_position = level.spawn_point.global_position
	player.drone_backpack.spawn_drone()
func switch_player_ui_to_base():#needed to display heads you brought back to base
	player.switch_ui_to_base()
func switch_player_ui_to_mission():#needed to display heads you have during a mission
		player.switch_ui_to_mission()
func reset_player_health():#resets player health to avoid death scene animation looping
	player.health.health = player.health.max_health
func reset_player_stats():#resets the player shield and weapon upgrades
	player.weapon_backpack.bullet_strategy_array.resize(0)
	player.drone_backpack.bullet_strategy_array.resize(0)
	player.drone_backpack.current_drone = null
	player.drone_backpack.clear_current_drone()
	player.shield.queue_free()
	var new_basic_shield: BaseShield = basic_shield.instantiate()
	player.add_child(new_basic_shield)
	new_basic_shield.global_position = player.global_position
	new_basic_shield.initialize()
###################################################################################
###################################################################################
func load_enemy_level():
	get_player()
	get_level()
	fade_in()
	await animation_player.animation_finished
	get_next_enemy_level()
	call_deferred("remove_player")
	call_deferred("remove_level")
	call_deferred("load_new_level")
	set_objective()
	clear_enemy_array()
	set_next_difficulty_enemies()
	await get_tree().create_timer(0.5).timeout
	get_spawn_markers()
	spawn_objectives()
	get_shiny_rock_markers()
	call_deferred("add_shiny_rocks")
	add_spawners()
	add_player()
	GlobalDifficulty.in_mission = true
	switch_player_ui_to_mission()
	reset_player_health()
	fade_out()
	difficulty_timeout.start()
func load_base_level():
	get_player()
	get_level()
	fade_in()
	call_deferred("remove_player")
	call_deferred("remove_level")
	call_deferred("load_main_level")
	transfer_currency()
	clear_enemy_array()
	GlobalDifficulty.in_mission = false
	add_player()
	switch_player_ui_to_base()
	reset_mission_progress()
	reset_player_health()
	fade_out()
	difficulty_timeout.stop()


func player_dead_load_base_level():
	get_player()
	get_level()
	fade_in()
	await animation_player.animation_finished
	reset_player_health()
	call_deferred("remove_player")
	call_deferred("remove_level")
	call_deferred("load_main_level")
	clear_currency()
	clear_enemy_array()
	GlobalCurrency.score = 0
	GlobalCurrency.itemxp = 0
	GlobalCurrency.itemxp_coeficient = 20
	GlobalDifficulty.in_mission = false
	call_deferred("reset_player_stats")
	add_player()
	switch_player_ui_to_base()
	reset_mission_progress()
	fade_out()
	difficulty_timeout.stop()

func deffered_enemy_level():
	call_deferred("load_enemy_level")
func deffered_main_level():
	call_deferred("load_base_level")
	
