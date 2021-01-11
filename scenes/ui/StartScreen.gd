extends "BaseUI.gd"


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		if app_state:
			app_state.set_trigger("enter")
