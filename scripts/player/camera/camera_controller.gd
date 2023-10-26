extends BoneAttachment3D

class_name CameraController

@export var camera_bob: CameraMotionProfile;
@export var camera: Camera3D;

var time: float = 0;

func _process(delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("down", "up"));
	
	if(Input.is_action_pressed("sprint") && input_vector.y > 0):
		time += delta;
	elif(Input.is_action_just_released("sprint")):
		time = 0;
	else:
		time += delta / camera_bob.sprint_modifier;
		
	process_motion(input_vector, time, delta);

func process_motion(input_vector: Vector2, time: float, delta: float) -> void:
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -camera_bob.process_motion(camera, input_vector * Vector2(-1,1), time), delta * camera_bob.lean_speed);
