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
	
	if controller.movement_direction == Vector2.ZERO or sign(controller.movement_direction.x) != sign(body.velocity.x):
		body.apply_friction(constants.traction)
	if body.velocity.x <= constants.air_speed * delta and body.velocity.x + delta_v.x * delta > constants.air_speed * delta:
		body.velocity.x = constants.air_speed * delta * sign(body.velocity.x)
		delta_v.x = 0
	
	if Input.is_action_just_pressed("Down") and body.velocity.y <= 0:
		body.velocity.y = -constants.falling_speed * delta
		delta_v.y = 0
	if controller.movement_direction.y < -.4 and can_fall_thru_platform:
		passthru_platform_checker.fall_thru = true
	else:
		passthru_platform_checker.fall_thru = false
	return delta_v

func decide_attack() -> bool:
	if controller.special_state == controller.special_pressed:
		if controller.movement_direction.y >= .7:
			state.update_state("Up Special")
			return true
		if abs(controller.movement_direction.x) >= .7:
			state.update_state("Side Special")
			return true
	if controller.crush_direction != Vector2.ZERO and can_tilt:
		if controller.crush_direction.y > .7:
			state.update_state("Uair")
			return true
		if controller.crush_direction.y < -.7:
			state.update_state("Dair")
			return true
		if abs(controller.crush_direction.x) > .7:
			if sign(controller.crush_direction.x) == body.facing_direction:
				state.update_state("Fair")
				return true
			if sign(controller.crush_direction.x) != body.facing_direction:
				state.update_state("Bair")
				return true
	elif controller.crush_direction == Vector2.ZERO and controller.attack_state == controller.attack_pressed:
		state.update_state("Nair") 
		return true
	return false
