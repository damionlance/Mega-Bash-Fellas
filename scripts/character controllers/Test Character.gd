extends CharacterBody3D

@export var player := true

@onready var state := $"State Machine"
@onready var controller := $"Controller"
var delta_v := Vector2.ZERO
var facing_direction := 1
var max_horizontal_velocity := 0.0

var can_jump := true
var consecutive_jumps := 0

var active_attack : Node

signal has_been_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	if player:
		controller.set_script(load("res://scripts/character controllers/Controller Inputs.gd"))
		controller._ready()
		controller.set_process(true)
	else:
		controller.set_script(load("res://scripts/character controllers/AI Inputs.gd"))
		controller._ready()
		controller.set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rotation.y = PI if facing_direction == -1 else 0
	
	can_jump = true
	if consecutive_jumps == $"State Machine/Aerial Movement".jumps_allowed:
		can_jump = false
	
	velocity += Vector3(delta_v.x, delta_v.y, 0) * delta
	move_and_slide()
	delta_v = Vector2.ZERO
	pass

func apply_friction(friction):
	if sign(velocity.x - friction * sign(velocity.x)) != sign(velocity.x):
		velocity.x = 0
		return
	velocity.x -= friction * sign(velocity.x)
