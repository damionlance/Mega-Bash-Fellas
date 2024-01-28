extends Node

#public variables
var state_dictionary : Dictionary
var current_state = null
var previous_state = null

var player_number : String

signal animation_finished

#onready variables
@onready var body = get_parent()
var grabbed_body = null
var _delta := 0.0166

# Called when the node enters the scene tree for the first time.
func _ready():
	player_number = "P" + str(body.player_number) + "_"
	if not "level_loaded" in get_tree().get_current_scene():
		queue_free()
		return
	await get_tree().get_current_scene().level_loaded
	update_state("Idle")
	body.connect("has_been_hit", enter_hitstun)

func _physics_process(delta):
	_delta = delta
	current_state.update(delta)

func update_state( newstate ):
	if player_number == "P2_": print(newstate)
	previous_state = current_state
	current_state = state_dictionary[newstate]
	current_state.reset(_delta)

func enter_hitstun(grab, grab_position, hitstun_frames):
	if grab:
		update_state("Grabbed")
		current_state.grab_position = grab_position
		return
	update_state("Hitstun")
	current_state.wait_time = hitstun_frames

func finished_animation():
	emit_signal("animation_finished")
