extends Node3D

signal level_loaded

var stage_size := Vector3(20, 20, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Heyy!")
	emit_signal("level_loaded")
	pass # Replace with function body.

func _process(delta):
	if $Body.stocks == 0:
		return
		get_tree().quit()
	if $Body2.stocks == 0:
		$PhantomCamera3D.erase_follow_group_node($"Body2/Camera Tracking Node")
		var Body2
		if $Body2.character_name == "Fella":
			Body2 = preload("res://scenes/characters/PB.tscn").instantiate()
		else:
			Body2 = preload("res://scenes/characters/Fella.tscn").instantiate()
		Body2.player_number = 2
		Body2.player = false
		Body2.stocks = 6
		Body2.set_owner(self)
		$Body2.queue_free()
		add_child(Body2)
		Body2.name = "Body2"
		$Body2.state.update_state("Respawn")
		$Body.state.update_state("Respawn")
