extends "res://scenes/game/3d/BaseLevel3D.gd"

const Character3D = preload("Character3D.gd")

func _on_Area_body_entered(body):
	# Victory
	if body is Character3D:
		if app_state:
			app_state.set_param("Game/End/win", true)
			app_state.set_trigger("game_end")

func _on_FallDeathArea_body_entered(body):
	# Game Over
	if body is Character3D:
		if app_state:
			app_state.set_param("Game/End/win", false)
			app_state.set_trigger("game_end")
