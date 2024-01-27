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

@export var traction := 2.2

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

func decide_attack() -> bool:
	if Input.is_action_just_pressed("Special"):
		if controller.movement_direction.y >= .7:
			state.update_state("Up Special")
			return true
		if abs(Input.get_axis("Left", "Right")) >= .7:
			state.update_state("Side Special")
			return true
	if Input.is_action_just_pressed("Grab"):
		state.update_state("Grab")
		return true
	if Input.get_vector("Crush Left", "Crush Right", "Crush Down", "Crush Up") != Vector2.ZERO and can_tilt:
		if Input.get_action_strength("Crush Up") > .7:
			state.update_state("UTilt")
			return true
		if Input.get_action_strength("Crush Down") > .7:
			state.update_state("DTilt")
			return true
		if abs(Input.get_axis("Crush Left", "Crush Right")) > .7:
			state.update_state("FTilt")
			return true
	elif Input.get_vector("Left", "Right", "Down", "Up").length() < 0.25:
		if Input.is_action_just_pressed("Attack"):
			state.update_state("Jab")
			return true
	return false
