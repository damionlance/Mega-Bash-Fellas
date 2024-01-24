extends Node
class_name GroundedMovement

@export var sprint_speed := 990.0
@export var frames_to_sprint := 11
@export var dash_speed := 855.0
@export var base_dash_acceleration := 420.0
@export var additional_dash_acceleration := 1400.0
@export var walk_speed := 720.0
@export var dodge_roll := 1980.0
@export var tech_roll := 3500.0
var can_crush := false
var can_tilt := false
var grabbing := false

@export var landing_lag := 4

@export var traction := 1.6

@onready var body := find_parent("Body*")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var animation_tree = body.find_child("Animation Tree")

@onready var passthru_platform_checker := $"../../../Passable Platform Checker"
var current_speed := 0

func grounded_movement_processing(delta, delta_v) -> Vector2:
	if abs(body.velocity.x) > sprint_speed * delta:
		body.apply_friction(traction * 2)
		if abs(body.velocity.x) < sprint_speed * delta:
			body.velocity.x = sign(body.velocity.x) * sprint_speed * delta
	
	return delta_v
	
	pass

func decide_attack():
	if controller.crush_direction != Vector2.ZERO and can_tilt:
		if controller.crush_direction.y > .8:
			state.update_state("UTilt")
			return
		if controller.crush_direction.y < -.8:
			state.update_state("DTilt")
			return
		if abs(controller.crush_direction.x) > .8:
			state.update_state("FTilt")
			return
	elif controller.movement_direction == Vector2.ZERO:
		if controller.attempting_attack:
			if grabbing:
				pass
				return
			state.update_state("Jab")
			return
	pass
