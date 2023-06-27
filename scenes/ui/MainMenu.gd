extends "BaseUI.gd"

@onready var start_game_btn = $"%StartGame"


func _ready():
	start_game_btn.grab_focus()

func _on_StartGame_pressed():
	if app_state:
		$AnimationPlayer.play("exit")

func _on_Quit_pressed():
	if app_state:
		app_state.set_trigger("quit")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "exit":
		if app_state:
			app_state.set_trigger("start_game")
