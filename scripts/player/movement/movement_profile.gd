extends Resource

class_name MovementProfile

@export var speed: float = 7500;
@export var jump_force: float = 5;
@export var gravity: float = -9.8;
@export var gravity_scale: float = 0.3;
@export var sprint_magnifier: float = 1.5;
@export var slide_speed_dropoff: Curve;
