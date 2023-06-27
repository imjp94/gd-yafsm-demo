extends "res://scenes/ui/BaseUI.gd"

@onready var title = $PanelContainer/CenterContainer/VBoxContainer/Label

func _ready():
	if app_state:
		var win = app_state.get_param("Game/End/win", false)
		if win:
			title.text = "Victory!"
		else:
			title.text = "Game Over"

func _input(event):
	if event.is_action_pressed("ui_accept"):
		app_state.set_trigger("continue")
		accept_event()
