extends Resource

class_name CameraMotionProfile

@export var lean: float = 3;
@export var lean_speed: float = 10;
@export var bob_magnitude: float = 0.03;
@export var bob_pace: float = 19;

func process_motion(camera: Camera3D, vector: Vector2, moving_time: float) -> float:
	var corrected_rotation: float = Vector2(lean * vector.x, 0).rotated(camera.rotation.y).x;
	camera.position.y = sin(moving_time * bob_pace * clamp(abs(vector.y) + abs(vector.x), -1, 1)) * bob_magnitude;
	return corrected_rotation;
