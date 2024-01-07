extends Node3D

signal level_loaded
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("level_loaded")
	pass # Replace with function body.
