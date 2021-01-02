extends KinematicBody


onready var smp = $StateMachinePlayer

export var speed = 1.0
export var damping = 0.1

var velocity = Vector3.ZERO
var walk = Vector3.ZERO

var _last_jump = 0
var _jump_count = 0


func _ready():
	smp.connect("updated", self, "_on_StateMachinePlayer_updated")
	smp.connect("transited", self, "_on_StateMachine_transited")

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		walk += Vector3.LEFT
	if Input.is_action_pressed("ui_right"):
		walk += Vector3.RIGHT
	if Input.is_action_pressed("ui_down"):
		walk += Vector3.BACK
	if Input.is_action_pressed("ui_up"):
		walk += Vector3.FORWARD
	walk = walk.normalized()

	smp.set_param("on_floor", is_on_floor())
	smp.set_param("walk", walk.abs().length())

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		smp.set_trigger("space")

func jump():
	velocity += Vector3.UP * 10
	_last_jump = OS.get_system_time_msecs()
	_jump_count += 1

func _on_StateMachinePlayer_updated(state, delta):
	velocity += Vector3.DOWN * 9.8 * delta
	match state:
		"Idle":
			pass
		"Walk":
			velocity += walk * speed * delta
			walk = Vector3.ZERO
		"Jump":
			_jump_count = 0
			jump()
			smp.set_param("jump_count", _jump_count)
		"Jump(n)":
			jump()
			smp.set_param("jump_count", _jump_count)
		"Fall":
			smp.set_param("jump_elapsed", OS.get_system_time_msecs() - _last_jump)
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity.x *= pow(1.0 - damping, delta)
	velocity.z *= pow(1.0 - damping, delta)

func _on_StateMachine_transited(from, to):
	prints("Transition(%s -> %s)" % [from, to])
