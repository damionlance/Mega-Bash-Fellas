extends CharacterBody3D

@export var player := true
@export var player_number : int = 1
@export var weight : float = 1.0
@export var character_name : String

@onready var state := $"State Machine"
@onready var controller := $"Controller"
@onready var hitbox_handler := $"Hitboxes"
@onready var grab_position := $"Grab Position"
@onready var stage_root := get_node("/root/Test Level")
@onready var pcam = stage_root.find_child("PhantomCamera3D")

var delta_v := Vector2.ZERO
var facing_direction := 1
var max_horizontal_velocity := 0.0
var slide_off_ledge = false
var previous_grounded_position
var last_wall_normal := 0.0
var wall_jump_counter := 0

var can_jump := true
var consecutive_jumps := 0

var current_damage := 0.0

var attacking := false
var special := false
var damaged := false

var active_attack : Node

signal has_been_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Animation Tree".active = true
	print(name)
	if player:
		controller.set_script(load("res://scripts/character controllers/Controller Inputs.gd"))
		controller._ready()
		controller.set_process(true)
		controller.set_process_input(true)
		$"AI Probes".queue_free()
	else:
		controller.set_script(load("res://scripts/character controllers/AI Inputs.gd"))
		controller._ready()
		controller.set_process(true)
	pcam.append_follow_group_node($"Camera Tracking Node")
	$Hitboxes.reset_hitboxes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation.y = PI if facing_direction == -1 else 0
	
	can_jump = true
	if consecutive_jumps == $"State Machine/Aerial Movement".constants.jumps_allowed:
		can_jump = false
	
	velocity += Vector3(delta_v.x, delta_v.y, 0) * delta
	test_edge(delta)
	move_and_slide()
	delta_v = Vector2.ZERO
	slide_off_ledge = true
	
	if is_on_wall():
		wall_jump_counter = 0
		last_wall_normal = get_last_slide_collision().get_normal().x/abs(get_last_slide_collision().get_normal().x)
	if not is_on_wall():
		wall_jump_counter += 1
		if wall_jump_counter == 3:
			last_wall_normal = 0

func apply_friction(friction):
	if sign(velocity.x - friction * sign(velocity.x)) != sign(velocity.x):
		velocity.x = 0
		return
	velocity.x -= friction * sign(velocity.x)

func test_edge(delta):
	if not is_on_floor() or velocity.x == 0 or velocity.y > 0:
		return
	var can_teeter = false
	if facing_direction == sign(velocity.x): 
		if Input.get_axis(state.player_number + "Left", state.player_number + "Right") == 0:
			can_teeter = true
			
	
	if can_teeter or not slide_off_ledge:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(global_position + (velocity * delta) + Vector3(0, 0.05, 0), global_position + (velocity * delta) - Vector3(0, 0.05, 0), 3)
		var result = space_state.intersect_ray(query)
		if not result:
			query = PhysicsRayQueryParameters3D.create(global_position + (velocity * delta) - Vector3(0, 0.05, 0), global_position - (velocity * delta) - Vector3(0, 0.05, 0), 3)
			result = space_state.intersect_ray(query)
			if result:
				global_position = result.position
				global_position.x -= sign(velocity.x) * 0.1
				velocity.x = 0
				delta_v.x = 0
				state.update_state("Teeter")
				return
		return
