extends Node

const StateDirectory = preload("addons/imjp94.yafsm/src/StateDirectory.gd")

export(PackedScene) var splash_screen_scn
export(PackedScene) var start_screen_scn
export(PackedScene) var main_menu_scn
export(PackedScene) var level_select_scn
export(PackedScene) var game_scn

onready var app_state = $AppState


func _on_AppState_transited(from, to):
	# Create StateDirectory to handle nested state better, not required for simple state machine
	var from_dir = StateDirectory.new(from)
	var to_dir = StateDirectory.new(to)

	# Handle previous scene
	var prev_scene
	if from_dir.is_nested():
		if from_dir.is_exit():
			prev_scene = get_node_or_null(from_dir.get_base())
	else:
		prev_scene = get_node_or_null(from)
	
	if prev_scene:
		prev_scene.queue_free()

	# Handle next scene
	var next_scene
	match to_dir.next():
		"SplashScreen":
			next_scene = splash_screen_scn.instance()
		"StartScreen":
			next_scene = start_screen_scn.instance()
		"MainMenu":
			next_scene = main_menu_scn.instance()
		"LevelSelect":
			next_scene = level_select_scn.instance()
		"Game":
			match to_dir.next(): # Match nested state
				"Entry": # Game/Entry
					next_scene = game_scn.instance()
		"Exit":
			get_tree().quit()
	if next_scene:
		next_scene.name = to_dir.get_base()
		next_scene.set("app_state", app_state)
		add_child(next_scene)
