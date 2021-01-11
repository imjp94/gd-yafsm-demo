extends "BaseUI.gd"

export(PackedScene) var level_3d_scn
export(PackedScene) var level_2d_scn

onready var restore_last_session = $PanelContainer/CenterContainer/VBoxContainer/VBoxContainer/RestoreLastSession


func _ready():
	if app_state:
		restore_last_session.disabled = !app_state.has_param("last_level")

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			app_state.set_trigger("back")

func _on_RestoreLastSession_pressed():
	if app_state:
		app_state.set_trigger("level_selected")

func _on_Select3D_pressed():
	if app_state:
		# Example of param "local" to nested state "Game", which will be automatically erased on exit, "Game/Exit"
		app_state.set_param("Game/level_scn", level_3d_scn)
		app_state.set_trigger("level_selected")

func _on_Select2D_pressed():
	if app_state:
		# Example of param "local" to nested state "Game", which will be automatically erased on exit, "Game/Exit"
		app_state.set_param("Game/level_scn", level_2d_scn)
		app_state.set_trigger("level_selected")
