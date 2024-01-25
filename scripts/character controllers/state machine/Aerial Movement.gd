extends Node

class_name AerialMovement

#warning-ignore:unused_private_class_variable

@export var air_speed := 892.0 #1992
@export var base_air_acceleration := 350.0 #480
@export var additional_air_acceleration := 500.0 # 1440
@export var traction := 1.0
@export var falling_speed := 1280.0 #1680
@export var gravity := 5200.88

var time_of_jump
var time_of_double_jump

@export var jump_force := 1300.0
@export var double_jump_force := 1600.2
@export var short_force := 860.0 # 1260

@export var jump_squat := 4
@export var jumps_allowed := 1
var delta_v
var entering_jump_angle

@onready var body := find_parent("Body*")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var animation_tree = body.find_child("Animation Tree")
@onready var passthru_platform_checker := $"../../../Passable Platform Checker"
var can_crush := false
var can_tilt := false

func _ready():
	time_of_jump = jump_force / gravity
	time_of_double_jump = double_jump_force / gravity

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

func decide_attack():
	
	if controller.crush_direction != Vector2.ZERO and can_tilt:
		if controller.crush_direction.y > .8:
			state.update_state("Uair")
			return
		if controller.crush_direction.y < -.8:
			state.update_state("Dair")
			return
		if abs(controller.crush_direction.x) > .8:
			if sign(controller.crush_direction.x) == body.facing_direction:
				state.update_state("Fair")
				return
			if sign(controller.crush_direction.x) != body.facing_direction:
				state.update_state("Bair")
				return
	pass
