extends Node

#public variables
var state_dictionary : Dictionary
var current_state = null
var previous_state = null

var target_body

@onready var ledge = get_tree().get_current_scene().find_child("Ledge")
@onready var ledge2 = get_tree().get_current_scene().find_child("Ledge2")

#onready variables
@onready var body = get_parent().get_parent()
@onready var astar = get_tree().get_current_scene().get_node("%AStar")
@onready var player_state := $"../../State Machine"
@onready var player_number : String = player_state.player_number
var point_path := []

var _delta := 0.0166

var list_of_possible_actions := []

# Called when the node enters the scene tree for the first time.
func _ready():
	if not "level_loaded" in get_tree().get_current_scene():
		queue_free()
		return
	await get_tree().get_current_scene().level_loaded
	update_state("Idle")
	body.connect("has_been_hit", enter_hitstun)

func _physics_process(delta):
	if body.state.current_state.state_name == "Respawn":
		reset_inputs()
		update_state("Walk Towards Opponent")
	if list_of_possible_actions.size()> 0:
		var rand = randi()%list_of_possible_actions.size() * 1.3
		if rand < list_of_possible_actions.size():
			update_state(list_of_possible_actions[rand])
	_delta = delta
	current_state.update(delta)
	list_of_possible_actions.clear()

func update_state( newstate ):
	previous_state = current_state
	current_state = state_dictionary[newstate]
	current_state.reset(_delta)

func update_path( target : Vector3 ):
	point_path = astar.find_path(body.global_position, target)
	var x = 0
	for i in point_path.size():
		if x + 1 >= point_path.size():
			break
		if point_path[x].y == point_path[x+1].y:
			point_path.pop_front()
		else:
			x+=1

func enter_hitstun(hitstun_frames):
	update_state("Hitstun")
	current_state.wait_time = hitstun_frames

func probe_for_object(from, to, collision_mask) -> Dictionary:
	var space_state = body.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
	var result = space_state.intersect_ray(query)
	return space_state.intersect_ray(query)
	

func insert_action(action : String):
	if list_of_possible_actions.has(action):
		return
	list_of_possible_actions.append(action)

func release_movement():
	Input.action_release(player_number + "Up")
	Input.action_release(player_number + "Down")
	Input.action_release(player_number + "Left")
	Input.action_release(player_number + "Right")

func release_attacks():
	Input.action_release(player_number + "Crush Up")
	Input.action_release(player_number + "Crush Down")
	Input.action_release(player_number + "Crush Left")
	Input.action_release(player_number + "Crush Right")
	Input.action_release(player_number + "Attack")
	Input.action_release(player_number + "Special")
	Input.action_release(player_number + "Shield")
	Input.action_release(player_number + "Grab")
	Input.action_release(player_number + "Jump")

func reset_inputs():
	Input.action_release(player_number + "Up")
	Input.action_release(player_number + "Down")
	Input.action_release(player_number + "Left")
	Input.action_release(player_number + "Right")
	Input.action_release(player_number + "Crush Up")
	Input.action_release(player_number + "Crush Down")
	Input.action_release(player_number + "Crush Left")
	Input.action_release(player_number + "Crush Right")
	Input.action_release(player_number + "Attack")
	Input.action_release(player_number + "Special")
	Input.action_release(player_number + "Shield")
	Input.action_release(player_number + "Grab")
	Input.action_release(player_number + "Jump")
