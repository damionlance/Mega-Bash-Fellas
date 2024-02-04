extends Area3D

@onready var state := $"../../State Machine"
@onready var body := $"../../"
@export var enabled := true
var velocity_enabled := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	monitoring = true
	if body.velocity.y > 0 or not enabled or state.current_state.state_name == "Damage Fly":
		monitoring = false


func _on_area_entered(area):
	state.update_state("Ledge Grab")
	body.global_position = area.global_position - $"../Ledge Position".position
	match area.grabbable_direction:
		"Left":
			body.facing_direction = 1
		"Right":
			body.facing_direction = -1
