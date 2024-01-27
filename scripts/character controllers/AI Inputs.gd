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

var jump_buffer := 0
var jump_timer := 5

var attempting_jump := false
var allow_jump := true
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

# button input states
var jump_input := false
var shield_input := false
var attack_input := false
var special_input := false

var attempting_tilt := false
var attempting_attack := false


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

var grab_state := 0
enum {
	grab_pressed = 1,
	grab_held = 2,
	grab_released = 0
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
var pivot_entered := false

var move_control_stick_allowed := true

# Called when the node enters the scene tree for the first time.
func _ready():
	var state = load("res://scenes/tools/AI Finite State Machine.tscn").instantiate()
	add_child(state)

func _process(_delta):
	if input_strength > .9:
		input_strength = 1
	
	if jump_input:
		jump_state = jump_pressed if jump_state == 0 else jump_held
	else: jump_state = jump_released
	if shield_input:
		shield_state = shield_pressed if shield_state == 0 else shield_held
	else: shield_state = shield_released
	if attack_input:
		attack_state = attack_pressed if attack_state == 0 else attack_held
		attempting_attack = true
	else: 
		attack_state = attack_released
		attempting_attack = false
	if special_input:
		special_state = special_pressed if special_state == 0 else special_held
		attempting_attack = true
	else: 
		special_state = special_released
		if attack_state == 0:
			attempting_attack = false
	if crush_direction != Vector2.ZERO:
		attempting_attack = true
	elif attack_state == 0 and special_state == 0:
		attempting_attack = false
	
	input_handling()

func input_handling():
	
	var resetting_collision = false
	var jump_released_since_jump = false
	
	if pivot_entered:
		pivot_allowed = true
	if pivot_allowed:
		pivot_timer += 1
		if pivot_timer == pivot_time_buffer:
			pivot_allowed = false
			pivot_timer = 0
	if jump_state == jump_pressed:
		attempting_jump = true
	elif jump_state == jump_held and jump_buffer < jump_timer:
		attempting_jump = true
		jump_buffer += 1
	else: 
		attempting_jump = false
		jump_buffer = 0
	if shield_state == shield_pressed:
		attempting_shield = true
	else: 
		attempting_shield = false
	

func wave_dash(direction : int, max_length : bool):
	if move_control_stick_allowed:
		move_control_stick_allowed = false
		if can_jump:
			short_hop()
			await get_tree().process_frame
			movement_direction.x = direction
			movement_direction.y = -0.15
			shield_input = true
			await get_tree().process_frame
			shield_input = false
			movement_direction.y = 0
			move_control_stick_allowed = true
		else:
			move_control_stick_allowed = true

var can_jump := true
func full_hop():
	if can_jump:
		can_jump = false
		jump_input = true
		await get_tree().create_timer(.15).timeout
		jump_input = false
		can_jump = true

func short_hop():
	if can_jump:
		can_jump = false
		jump_input = true
		await get_tree().process_frame
		jump_input = false
		can_jump = true
