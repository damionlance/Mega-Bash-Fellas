extends Node

var movement_direction := Vector2.ZERO # Always Normalized
var input_strength := 0.0
var neutral_zone := 0.2

var horizontal_direction
var vertical_direction
enum {
	neutral,
	up,
	right,
	down,
	left
}
var previous_direction := Vector2.ZERO

var attempting_jump := false
var allow_jump := false
var attempting_shield := false
var allow_shield := false
var attempting_dive := false
var allow_dive := true
var spin_allowed := false
var pivot_allowed := false
var spin_timer := 0
var spin_buffer := 30
var pivot_timer := 0
var pivot_time_buffer := 30
var is_on_floor := false
var attempting_throw := false
var restricted_movement := false

# Spin variables
var angle := [0.0, 0.0]
var turning := 0
var spin_entered := false
var spin_jump_start := Vector2.ZERO
var spin_jump_angle := 0.0
var spin_jump_sign := int(0)

# pivot variables
var pivot_buffer = []

var jump_buffer := 0
var jump_timer := 5

var jump_state := 0
enum {
	jump_pressed = 1,
	jump_held = 2,
	jump_released = 0
}

var dive_state := 0
enum {
	dive_pressed = 1,
	dive_held = 2,
	dive_released = 0
}

var throw_state := 0
enum {
	throw_pressed = 1,
	throw_held = 2,
	throw_released = 0
}

var shield_state := 0
enum {
	shield_pressed = 1,
	shield_held = 2,
	shield_released = 0
}

var attack_state := 0
enum {
	attack_pressed = 1,
	attack_held = 2,
	attack_released = 0
}

var special_state := 0
enum {
	special_pressed = 1,
	special_held = 2,
	special_released = 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.use_accumulated_input = false
	pivot_buffer.resize(5)
	for i in 5:
		pivot_buffer[i] = Vector2.ZERO
	pass # Replace with function body.

func _process(_delta):
	movement_direction = Input.get_vector("Left","Right", "Down", "Up")
	input_strength = movement_direction.length()
	if input_strength > .9:
		input_strength = 1
	
	pivot_buffer.push_front(movement_direction)
	pivot_buffer.pop_back()
	
	if Input.get_action_strength("Jump"):
		jump_state = jump_pressed if jump_state == 0 else jump_held
	else: jump_state = jump_released
	if Input.get_action_strength("Shield"):
		shield_state = shield_pressed if shield_state == 0 else shield_held
	else: shield_state = shield_released
	if Input.get_action_strength("Attack"):
		attack_state = attack_pressed if attack_state == 0 else attack_held
	else: attack_state = attack_released
	if Input.get_action_strength("Special"):
		special_state = special_pressed if special_state == 0 else special_held
	else: special_state = special_released
	
	input_handling()

func input_handling():
	
	var resetting_collision = false
	var jump_released_since_jump = false
	
	if jump_state == jump_pressed and allow_jump:
		attempting_jump = true
	elif jump_state == jump_held and jump_buffer < jump_timer:
		attempting_jump = true
		jump_buffer += 1
	else: 
		attempting_jump = false
	if shield_state == shield_pressed:
		attempting_shield = true
	else: 
		attempting_shield = false
	
	if (jump_state == jump_released):
			jump_buffer = 0

var stayed_still_buffer = 5
var stayed_still_timer = 0
var resetplz = false
