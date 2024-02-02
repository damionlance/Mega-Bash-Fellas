extends Node3D

signal level_loaded

var stage_size := Vector3(30, 30, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("level_loaded")
	pass # Replace with function body.

func _process(delta):
	print(Engine.get_frames_per_second())
