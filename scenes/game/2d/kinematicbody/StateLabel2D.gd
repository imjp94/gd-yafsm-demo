extends Control

@export var stack_player_np: NodePath
@export var offset = Vector2.ZERO

var label = Label.new()
var camera2d
var stack_player


func _init():
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_vertical = SIZE_SHRINK_CENTER
	label.set_anchors_preset(PRESET_CENTER_TOP)
	label.text = "State"
	add_child(label)

func _ready():
	stack_player = get_node_or_null(stack_player_np)

func _process(delta):
	if stack_player:
		label.text = stack_player.get_current()
		label.position.x = label.size.x / 2 + offset.x
		label.position.y = -label.size.y + offset.y
