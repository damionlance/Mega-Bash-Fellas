@tool

extends AnimationPlayer

@export var run := false
var list_of_paths = ["../Animation Tree"]
var list_of_default_parameters = ["%Animation Tree:parameters/TimeScale/scale"]
var list_of_values = [float(1)]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		if run:
			run = false
			for animation_name in get_animation_list():
				var animation = get_animation(animation_name)
				for i in list_of_paths.size():
					if animation.find_track(list_of_default_parameters[i], Animation.TYPE_VALUE) == -1:
						var track_index = animation.add_track(Animation.TYPE_VALUE)
						animation.track_set_path(track_index, list_of_default_parameters[i])
						animation.track_insert_key(track_index, 0, float(list_of_values[i]))
