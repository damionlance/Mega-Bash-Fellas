extends Node3D

@onready var dash_particle := preload("res://scenes/particles/dash particle.tscn")

func instance_dash_particle():
	var new_dash_particle = dash_particle.instantiate()
	add_child(new_dash_particle)
	new_dash_particle.reparent(self)
	new_dash_particle.emitting = true
