extends Node3D

signal level_loaded

var stage_size := Vector3(20, 20, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("level_loaded")
	get_tree().get_current_scene()._fire_off_ready()
	pass # Replace with function body.
