extends "res://scenes/ui/BaseUI.gd"


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "splash":
		if app_state:
			app_state.set_trigger("splash_anim_finished")
