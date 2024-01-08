extends Node

class_name AerialMovement

#warning-ignore:unused_private_class_variable

@export var air_speed := 498.0
@export var base_air_acceleration := 120.0
@export var additional_air_acceleration := 360.0
@export var traction := 1.0
@export var falling_speed := 1680.0
@export var gravity := 13800.0

var time_of_jump
var time_of_double_jump

@export var jump_force := 2208.0
@export var double_jump_force := 2649.6
@export var short_force := 1260.0

@export var jump_squat := 3
@export var jumps_allowed := 1
var delta_v
var entering_jump_angle

@onready var body := find_parent("Body*")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var animation_tree = body.find_child("AnimationTree")
@onready var passthru_platform_checker := $"../../../Passable Platform Checker"

func _ready():
	time_of_jump = jump_force / gravity
	time_of_double_jump = double_jump_force / gravity
	print(time_of_jump)

# Helper Functions
func regular_aerial_movement_processing(delta, delta_v) -> Vector2:
	
	if controller.movement_direction == Vector2.ZERO or sign(controller.movement_direction.x) != sign(body.velocity.x):
		body.apply_friction(traction)
	
	if Input.is_action_just_pressed("Down") and body.velocity.y <= 0:
		body.velocity.y = -falling_speed * delta
		delta_v.y = 0
	if controller.movement_direction.y < -.4 and state.current_state.state_name != "Airdodge":
		passthru_platform_checker.fall_thru = true
	else:
		passthru_platform_checker.fall_thru = false
	return delta_v
