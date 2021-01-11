extends Control

export(NodePath) var stack_player_np
export var offset = Vector2.ZERO

var label = Label.new()
var camera2d
var stack_player


func _init():
	label.align = HALIGN_CENTER
	label.valign = VALIGN_CENTER
	label.size_flags_vertical = SIZE_SHRINK_CENTER
	label.set_anchors_and_margins_preset(PRESET_CENTER_TOP)
	label.text = "State"
	add_child(label)

func _ready():
	stack_player = get_node_or_null(stack_player_np)

func _process(delta):
	if stack_player:
		label.text = stack_player.get_current()
		label.rect_position.x = label.rect_size.x / 2 + offset.x
		label.rect_position.y = -label.rect_size.y + offset.y
