extends CharacterBody2D


@onready var smp = $StateMachinePlayer

@export var speed = 1.0
@export var damping = 0.1

var walk = Vector2.ZERO

var _last_jump = 0
var _jump_count = 0


func _ready():
	smp.connect("updated", _on_StateMachinePlayer_updated)
	smp.connect("transited", _on_StateMachine_transited)

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		walk += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		walk += Vector2.RIGHT
	walk = walk.normalized()

	smp.set_param("on_floor", is_on_floor())
	smp.set_param("walk", walk.abs().length())

	# NOTE: It is more efficient to run directly in _physics_process, this demo is to showcase how to handle logic in updated signal
	# velocity += Vector2.DOWN * 9.8
	# match smp.get_current():
	# 	"Idle":
	# 		pass
	# 	"Walk":
	# 		velocity += walk * speed
	# 		walk = Vector2.ZERO
	# 	"Jump":
	# 		_jump_count = 0
	# 		jump()
	# 		smp.set_param("jump_count", _jump_count)
	# 	"Jump(n)":
	# 		jump()
	# 		smp.set_param("jump_count", _jump_count)
	# 	"Fall":
	# 		smp.set_param("jump_elapsed", Time.get_ticks_msec() - _last_jump)
	# velocity = move_and_slide(velocity, Vector2.UP)
	# velocity.x *= pow(1.0 - damping, delta)

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		smp.set_trigger("space")

func jump():
	velocity += Vector2.UP * 300
	_last_jump = Time.get_ticks_msec()
	_jump_count += 1

func _on_StateMachinePlayer_updated(state, delta):
	# NOTE: It is more efficient to run directly in _physics_process, this demo is to showcase how to handle logic in updated signal
	velocity += Vector2.DOWN * 9.8
	match state:
		"Idle":
			pass
		"Walk":
			velocity += walk * speed
			walk = Vector2.ZERO
		"Jump":
			_jump_count = 0
			jump()
			smp.set_param("jump_count", _jump_count)
		"Jump(n)":
			jump()
			smp.set_param("jump_count", _jump_count)
		"Fall":
			smp.set_param("jump_elapsed", Time.get_ticks_msec() - _last_jump)
	move_and_slide()
	velocity.x *= pow(1.0 - damping, delta)

func _on_StateMachine_transited(from, to):
	prints("Transition(%s -> %s)" % [from, to])
