extends "BaseUI.gd"

@onready var continue_btn = $"%Continue"


func _ready():
	continue_btn.grab_focus()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		if app_state:
			get_tree().set_input_as_handled() # Must be set as handled, as Game.gd also listening same input
			app_state.set_trigger("continue")

func _on_Continue_pressed():
	if app_state:
		app_state.set_trigger("continue")

func _on_Quit_pressed():
	if app_state:
		get_tree().paused = false
		app_state.set_trigger("quit")
