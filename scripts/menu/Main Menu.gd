extends Control

@onready var fella_button = $"Fella Button"
@onready var pb_button = $"PB Button"
var level = preload("res://test_level.tscn").instantiate()
var character_fella = preload("res://scenes/characters/Fella.tscn").instantiate()
var character_PB = preload("res://scenes/characters/PB.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	fella_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fella_button_pressed():
	get_tree().get_root().add_child(level)
	character_PB.name = "Body2"
	character_fella.name = "Body"
	character_fella.player_number = 1
	character_PB.player_number = 2
	character_fella.player = true
	character_PB.player = false
	level.add_child(character_PB)
	level.add_child(character_fella)
	character_fella.owner = level
	character_PB.owner = level
	var packed_scene = PackedScene.new()
	get_tree().change_scene_to_packed(packed_scene)
	get_parent().queue_free()


func _on_pb_button_pressed():
	get_tree().get_root().add_child(level)
	character_PB.name = "Body"
	character_fella.name = "Body2"
	character_fella.player_number = 2
	character_PB.player_number = 1
	character_fella.player = false
	character_PB.player = true
	level.add_child(character_fella)
	level.add_child(character_PB)
	character_fella.owner = level
	character_PB.owner = level
	var packed_scene = PackedScene.new()
	get_tree().change_scene_to_packed(packed_scene)
	get_parent().queue_free()
	pass # Replace with function body.
