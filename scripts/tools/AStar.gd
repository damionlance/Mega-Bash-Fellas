extends Node3D

@export var draw_debug_cubes : bool = false

var grid_step := 1.0
var points := {}
var astar := AStar3D.new()

var box_mesh : BoxMesh = BoxMesh.new()
var red_material : StandardMaterial3D = StandardMaterial3D.new()
var green_material : StandardMaterial3D = StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	red_material.albedo_color = Color.RED
	green_material.albedo_color = Color.GREEN
	box_mesh.size = Vector3(0.25,0.25,0.25)
	var pathables = get_tree().get_nodes_in_group("pathable")
	add_points(pathables)
	connect_points()

func add_points(pathables : Array):
	for pathable in pathables:
		var space_state = get_world_3d().direct_space_state
		
		var mesh = pathable.get_child(0)
		var aabb : AABB = mesh.get_aabb()
		
		var start_point = mesh.global_position + Vector3(-aabb.size.x/2, aabb.size.y + 0.1, 0)
		
		var x_steps = (aabb.size.x / grid_step) + 1
		var height = aabb.size.y
		var exclude_list : Array = generate_exclude_list(pathable, pathables)
		for x in x_steps:
			var next_point = start_point + Vector3(x * grid_step, 0, 0)
			var end_point = next_point + Vector3(0, -height, 0)
			var query = PhysicsRayQueryParameters3D.create(next_point, end_point, 3, exclude_list)
			var result = space_state.intersect_ray(query)
			if result.size() != 0:
				add_point(result.position)
				create_nav_cube(result.position)

func connect_points():
	var space_state = get_world_3d().direct_space_state
	for point in points:
		var point_string = point.split(",")
		var point_position = Vector3(int(point_string[0]),int(point_string[1]),int(point_string[2]))
		
		# PREP THE RAYCAST VARIABLES
		var start_point = point_position - Vector3.UP
		var end_point = start_point - Vector3.UP * 3
		
		
		var coords = [-1, 0, 1]
		for x in coords:
			var query = PhysicsRayQueryParameters3D.create(start_point, end_point + Vector3(coords[x] * 4, 0, 0), 3)
			var result = space_state.intersect_ray(query)
			if result.size() != 0:
				var test_point = astar.get_point_position(astar.get_closest_point(result.position))
				if not astar.are_points_connected(points[point], points[world_to_astar(test_point)]):
					astar.connect_points(points[point], points[world_to_astar(test_point)])
			
			if coords[x] == 0: continue
			
			var test_point = astar.get_point_position(astar.get_closest_point(point_position + Vector3(coords[x],0,0)))
			if (test_point - point_position).length() < grid_step * 1.4 and test_point != point_position:
				if not astar.are_points_connected(points[point], points[world_to_astar(test_point)]):
					astar.connect_points(points[point], points[world_to_astar(test_point)])
		
		# CONNECT DROP POINTS
		

func create_nav_cube( position : Vector3 ):
	if draw_debug_cubes:
		var cube = MeshInstance3D.new()
		cube.mesh = box_mesh
		cube.material_override = red_material
		cube.global_position = position
		add_child(cube)

func world_to_astar(world_point: Vector3) -> String:
	var x = snappedf(world_point.x, grid_step)
	var y = snappedf(world_point.y, grid_step)
	var z = 0
	return "%d,%d,%d" % [x, y, z]

func add_point(point: Vector3):
	var id = astar.get_available_point_id()
	point.z = 0
	astar.add_point(id, point)
	points[world_to_astar(point)] = id

func find_path(from: Vector3, to: Vector3) -> Array:
	var start_id = astar.get_closest_point(from)
	var end_id = astar.get_closest_point(to)
	return astar.get_point_path(start_id, end_id)

func generate_exclude_list(object_to_not_exclude : Object, pathables : Array):
	var exclude_list := []
	for pathable in pathables:
		if pathable == object_to_not_exclude:
			continue
		exclude_list.append(pathable)
	return exclude_list
