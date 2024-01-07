extends Node3D

@onready var respawners = $Respawners.get_children()

signal respawn(body_name)
# Called when the node enters the scene tree for the first time.
func _ready():
	print(name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func respawn_entity(body, off_the_top):
	if not off_the_top:
		if respawners != null:
			var respawner = respawners[randi()%respawners.size()]
			body.global_position = respawner.global_position
			respawn.emit(body.name)
