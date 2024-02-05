extends Node

var movement_direction := Vector2.ZERO # Always Normalized
var crush_direction := Vector2.ZERO
var input_strength := 0.0
var neutral_zone := 0.2

@onready var player_state := $"../State Machine"
@onready var player_number = player_state.player_number

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

var move_control_stick_allowed := true

# Called when the node enters the scene tree for the first time.
func _ready():
	var state = load("res://scenes/tools/AI Finite State Machine.tscn").instantiate()
	add_child(state)


func wave_dash(direction : int, max_length : bool):
	if move_control_stick_allowed:
		move_control_stick_allowed = false
		if can_jump:
			short_hop()
			await get_tree().process_frame
			movement_direction.x = direction
			movement_direction.y = -0.15
			Input.action_press(player_number + "Shield")
			await get_tree().process_frame
			Input.action_release(player_number + "Shield")
			movement_direction.y = 0
			move_control_stick_allowed = true
		else:
			move_control_stick_allowed = true

var can_jump := true
func full_hop():
	if can_jump:
		can_jump = false
		Input.action_press(player_number + "Jump")
		await get_tree().create_timer(.15).timeout
		Input.action_release(player_number + "Jump")
		can_jump = true

func short_hop():
	if can_jump:
		can_jump = false
		Input.action_press(player_number + "Jump")
		await get_tree().process_frame
		Input.action_release(player_number + "Jump")
		can_jump = true
