extends Node

#public variables
var state_dictionary : Dictionary
var current_state = null
var previous_state = null

var target_body

#onready variables
@onready var body = get_parent().get_parent()
var _delta := 0.0166

# Called when the node enters the scene tree for the first time.
func _ready():
	if not "level_loaded" in get_tree().get_current_scene():
		queue_free()
		return
	await get_tree().get_current_scene().level_loaded
	update_state("Idle")

func _physics_process(delta):
	_delta = delta
	current_state.update(delta)

func update_state( newstate ):
	print(newstate)
	previous_state = current_state
	current_state = state_dictionary[newstate]
	current_state.reset(_delta)

func probe_for_object(from, to, collision_mask) -> Dictionary:
	var space_state = body.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	return space_state.intersect_ray(query)
