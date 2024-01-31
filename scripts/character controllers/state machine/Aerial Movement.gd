extends Node

class_name AerialMovement

#warning-ignore:unused_private_class_variable



var time_of_jump
var time_of_double_jump


var delta_v
var entering_jump_angle

@onready var body := find_parent("Body*")
@onready var state = find_parent("State Machine")
@onready var controller = body.find_child("Controller", false)
@onready var animation_tree = body.find_child("Animation Tree")
@onready var passthru_platform_checker := $"../../../Passable Platform Checker"

@export var constants : Resource

var can_crush := false
var can_tilt := false
var can_fall_thru_platform := true

func _ready():
	constants.jump_force / constants.gravity
	constants.double_jump_force / constants.gravity
	for child in get_children():
		child.constants = constants

# Helper Functions
func regular_aerial_movement_processing(delta, delta_v) -> Vector2:
	
	if Input.get_vector(state.player_number + "Left",state.player_number +  "Right", state.player_number + "Down", state.player_number + "Up") == Vector2.ZERO or sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) != sign(body.velocity.x):
		body.apply_friction(constants.traction)
	
	if body.velocity.x <= constants.air_speed * delta and body.velocity.x + delta_v.x * delta > constants.air_speed * delta:
		body.velocity.x = constants.air_speed * delta * sign(body.velocity.x)
		delta_v.x = 0
	
	if Input.is_action_just_pressed(state.player_number + "Down") and body.velocity.y <= 0:
		body.velocity.y = -constants.falling_speed * delta
		delta_v.y = 0
	if Input.get_action_strength(state.player_number + "Down") < -.4 and can_fall_thru_platform:
		passthru_platform_checker.fall_thru = true
	else:
		passthru_platform_checker.fall_thru = false
	return delta_v

func decide_attack() -> bool:
	if Input.is_action_just_pressed(state.player_number + "Special"):
		if Input.get_action_strength(state.player_number + "Up") >= .7:
			state.update_state("Up Special")
			return true
		if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) >= .7:
			state.update_state("Side Special")
			return true
		if Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up").length() < 0.2:
			state.update_state("Neutral Special")
			return true
	if Input.get_vector(state.player_number + "Crush Left", state.player_number + "Crush Right", state.player_number + "Crush Down", state.player_number + "Crush Up") != Vector2.ZERO and can_tilt:
		if Input.get_action_strength(state.player_number + "Crush Up") > .7:
			state.update_state("Uair")
			return true
		if Input.get_action_strength(state.player_number + "Crush Down") > .7:
			state.update_state("Dair")
			return true
		if abs(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) > .7:
			if sign(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) == body.facing_direction:
				state.update_state("Fair")
				return true
			if sign(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) != body.facing_direction:
				state.update_state("Bair")
				return true
	elif Input.get_vector(state.player_number + "Crush Left", state.player_number + "Crush Right", state.player_number + "Crush Down", state.player_number + "Crush Up") == Vector2.ZERO and Input.is_action_just_pressed(state.player_number + "Attack"):
		state.update_state("Nair") 
		return true
	return false
