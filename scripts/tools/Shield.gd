@tool
extends MeshInstance3D
@export_range(0.5, 2.5) var radius := 1.0
@export_color_no_alpha var color := Color.BLUE

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.size = Vector2(radius, radius)
	mesh.material.set_shader_parameter("color", color)
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		mesh.size = Vector2(radius, radius)
		mesh.material.set_shader_parameter("color", color)
