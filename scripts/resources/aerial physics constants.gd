extends Resource
class_name AerialPhysicsConstants

@export_group("Base Constants")
@export var jump_squat := 4
@export var jumps_allowed := 1
@export var air_dodge_strength := 2600.0
@export var gravity := 5200.88
@export var falling_speed := 1280.0 #1680

@export_group("Single Jump")
@export var jump_force := 1300.0
@export var short_force := 860.0 # 1260

@export_group("Double Jump")
@export var double_jump_force := 1600.2
@export var double_jump_speed_cap := 495

@export_group("Air Drift")
@export var traction := 1.3
@export var air_speed := 892.0 #1992
@export var base_air_acceleration := 350.0 #480
@export var additional_air_acceleration := 500.0 # 1440

@export_group("Up Special")
@export var up_special_velocity := 2000.0
@export var base_up_special_drift := 250.0
@export var additional_up_special_drift := 350.0
