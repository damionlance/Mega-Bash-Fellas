extends Node

var movement_direction := Vector2.ZERO # Always Normalized
var crush_direction := Vector2.ZERO
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
var attempting_attack := false

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

var previous_jump_state := 0
var jump_state := 0
enum {
	jump_pressed = 1,
	jump_held = 2,
	jump_released = 0
}

var previous_grab_state := 0
var grab_state := 0
enum {
	grab_pressed = 1,
	grab_held = 2,
	grab_released = 0
}

var previous_shield_state := 0
var shield_state := 0
enum {
	shield_pressed = 1,
	shield_held = 2,
	shield_released = 0
}
var previous_attack_state := 0
var attack_state := 0
enum {
	attack_pressed = 1,
	attack_held = 2,
	attack_released = 0
}

var previous_special_state := 0
var special_state := 0
enum {
	special_pressed = 1,
	special_held = 2,
	special_released = 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_buffer.resize(5)
	for i in 5:
		pivot_buffer[i] = Vector2.ZERO
	pass # Replace with function body.

func _input(event):
	if event.get_action_strength("Crush Up") - event.get_action_strength("Crush Down") - event.get_action_strength("Crush Left") - event.get_action_strength("Crush Right") == 0:
		attempting_attack = false
	if event.is_action_pressed("Attack"):
		attempting_attack = true
		attack_state = 1
	if event.is_action_released("Attack"):
		attempting_attack = false
		attack_state = 0
	if event.is_action_pressed("Special"):
		attempting_attack = true
		special_state = 1
	if event.is_action_released("Special"):
		attempting_attack = false
		special_state = 0
	if event.is_action_pressed("Shield"):
		shield_state = 1
	if event.is_action_released("Shield"):
		shield_state = 0
	if event.is_action_pressed("Grab"):
		attempting_attack = true
		grab_state = 1
	if event.is_action_released("Grab"):
		attempting_attack = false
		grab_state = 0
	if event.is_action_pressed("Jump"):
		jump_state = 1
	if event.is_action_released("Jump"):
		jump_state = 0

func _process(delta):
	crush_direction.x = Input.get_action_strength("Crush Right") - Input.get_action_strength("Crush Left")
	crush_direction.y = Input.get_action_strength("Crush Up") - Input.get_action_strength("Crush Down")
	movement_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	movement_direction.y = Input.get_action_strength("Up") - Input.get_action_strength("Down")
	
	if attempting_attack == false:
		if crush_direction != Vector2.ZERO:
			attempting_attack = true
	if grab_state == 1 and previous_grab_state == 1:
		grab_state = 2
	previous_grab_state = grab_state
	if attack_state == 1 and previous_attack_state == 1:
		attack_state = 2
	previous_attack_state = attack_state
	if shield_state == 1 and previous_shield_state == 1:
		shield_state = 2
	previous_shield_state = shield_state
	if special_state == 1 and previous_special_state == 1:
		special_state = 2
	previous_special_state = special_state
	if jump_state == 1 and previous_jump_state == 1:
		jump_state = 2
	previous_jump_state = jump_state
	
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
