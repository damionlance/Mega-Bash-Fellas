extends Node

class_name AerialMovement

#warning-ignore:unused_private_class_variable

@export var air_speed := 498.0
@export var base_air_acceleration := 120.0
@export var additional_air_acceleration := 360.0
@export var falling_speed := 1680.0
@export var gravity := 13800.0

@export var jump_force := 2208.0
@export var double_jump_force := 2649.6
@export var short_force := 1260.0

@export var jump_squat := 3
@export var jumps_allowed := 1
var delta_v
var entering_jump_angle

@onready var body = find_parent("Body")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var raycasts := body.find_child("RaycastHandler", false)
@onready var animation_tree = body.find_child("AnimationTree")

# Helper Functions
func regular_aerial_movement_processing() -> Vector3:
	delta_v = Vector3.ZERO
	
	return delta_v
