extends "BaseGame.gd"

const StateDirectory = preload("res://addons/imjp94.yafsm/src/StateDirectory.gd")

export(PackedScene) var load_sreen_scn
export(PackedScene) var pause_menu_scn
export(PackedScene) var game_end_screen_scns

var load_screen_instance
var pause_menu_instance
var game_end_screen_instance
var current_level_instance


func _ready():
	if app_state:
		app_state.connect("transited", self, "_on_AppState_transited")

func setup_level():
	if app_state:
		var level_scn = app_state.get_param("Game/level_scn")
		var last_level = app_state.get_param("last_level")
		if level_scn:
			# New level instance
			current_level_instance = level_scn.instance()
			if last_level:
				app_state.erase_param("last_level", false) # Remove last level, since we're starting new level
				last_level.queue_free() # IMPORTANT: Must be freed, otherwise it will cause memory leak
		else:
			# Restore last played level
			current_level_instance = last_level
		if current_level_instance:
			current_level_instance.set("app_state", app_state)
			add_child(current_level_instance)

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			app_state.set_trigger("pause")

func _on_AppState_transited(from, to):
	# Create StateDirectory to handle nested state better, not required for simple state machine
	var from_dir = StateDirectory.new(from)
	var to_dir = StateDirectory.new(to)

	match to_dir.next():
		"Game":
			match to_dir.next():
				"Load":
					load_screen_instance = load_sreen_scn.instance()
					load_screen_instance.set("app_state", app_state)
					add_child(load_screen_instance)
				"Pause":
					if not pause_menu_instance:
						pause_menu_instance = pause_menu_scn.instance()
						pause_menu_instance.set("app_state", app_state)
						if current_level_instance is Node2D:
							pause_menu_instance.anchor_left = -0.5
							pause_menu_instance.anchor_top = -0.5
							pause_menu_instance.anchor_right = 0.5
							pause_menu_instance.anchor_bottom = 0.5
						else:
							pause_menu_instance.set_anchors_and_margins_preset(Control.PRESET_WIDE)
					add_child(pause_menu_instance)
					get_tree().paused = true
				"Play":
					if from_dir.get_end() == "Load": # Just loaded
						if load_screen_instance.is_inside_tree():
							load_screen_instance.queue_free()
							load_screen_instance = null
							setup_level()
					get_tree().paused = false
					if pause_menu_instance:
						remove_child(pause_menu_instance) # Don't free yet, save for later
				"End":
					match to_dir.next():
						"Entry":
							game_end_screen_instance = game_end_screen_scns.instance()
							game_end_screen_instance.set("app_state", app_state)
							add_child(game_end_screen_instance)
							if current_level_instance is Node2D:
								game_end_screen_instance.anchor_left = -0.5
								game_end_screen_instance.anchor_top = -0.5
								game_end_screen_instance.anchor_right = 0.5
								game_end_screen_instance.anchor_bottom = 0.5
							else:
								game_end_screen_instance.set_anchors_and_margins_preset(Control.PRESET_WIDE)
							get_tree().paused = true # Stop interacting with game
						"Exit":
							get_tree().paused = false
				"Exit":
					if not ("End" in from): # Not from Game/End(not finished)
						remove_child(current_level_instance)
						app_state.set_param("last_level", current_level_instance)
						current_level_instance = null
					if game_end_screen_instance:
						game_end_screen_instance.queue_free()
