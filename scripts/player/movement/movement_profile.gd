extends Resource

class_name MovementProfile

@export var velocity_snap_modifier: Vector2 = Vector2(10,10);
@export var speed: Vector2 = Vector2(100, 100);
@export var jump_force: float = 5;
@export var gravity: float = -9.8;
@export var gravity_scale: float = 0.3;
@export var sprint_magnifier: float = 1.2;
@export var slide_speed_dropoff: Curve;
