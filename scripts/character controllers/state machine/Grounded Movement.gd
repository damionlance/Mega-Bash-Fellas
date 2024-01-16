extends Node
class_name GroundedMovement

@export var sprint_speed := 1320.0
@export var frames_to_sprint := 11
@export var dash_speed := 1140.0
@export var base_dash_acceleration := 120.0
@export var additional_dash_acceleration := 600.0
@export var walk_speed := 960.0

@export var landing_lag := 4

@export var traction := 1.6

@onready var body := find_parent("Body*")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var animation_tree = body.find_child("AnimationTree")

@onready var passthru_platform_checker := $"../../../Passable Platform Checker"
var current_speed := 0

func grounded_movement_processing(delta, delta_v) -> Vector2:
	if abs(body.velocity.x) > sprint_speed * delta:
		body.apply_friction(traction * 2)
		if abs(body.velocity.x) < sprint_speed * delta:
			body.velocity.x = sign(body.velocity.x) * sprint_speed * delta
	
	return delta_v
	
	pass
