extends Resource

class_name MovementProfile

@export var speed: float = 1000;
@export var jump_force: float = 10;
@export var gravity: float = -9.8;
@export var gravity_scale: float = 0.1;
@export var sprint_magnifier: float = 1.5;
@export var slide_speed_dropoff: Curve;
