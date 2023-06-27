extends Control

@export var stack_player_np: NodePath
@export var offset = Vector2.ZERO

var label = Label.new()
var stack_player


func _init():
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_vertical = SIZE_SHRINK_CENTER
	add_child(label)

func _ready():
	stack_player = get_node_or_null(stack_player_np)

func _process(delta):
	if Engine.is_editor_hint:
		return

	if stack_player:
		label.text = stack_player.get_current()
		var camera = get_viewport().get_camera()
		var world_pos = get_parent().global_transform.origin
		if camera.is_position_behind(world_pos):
			label.hide()
		else:
			if not label.visible:
				label.show()
			label.rect_pivot_offset = label.rect_size / 2
			label.set_position(camera.unproject_position(world_pos) - label.rect_size / 2 + offset)
