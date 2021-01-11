extends "res://scenes/game/2d/BaseLevel2D.gd"

const Character2D = preload("Character2D.gd")


func _on_Area2D_body_entered(body):
	if body is Character2D:
		if app_state:
			app_state.set_param("Game/End/win", true)
			app_state.set_trigger("game_end")

func _on_FallDeathArea2D_body_entered(body):
	if body is Character2D:
		if app_state:
			app_state.set_param("Game/End/win", false)
			app_state.set_trigger("game_end")
