extends BoneAttachment3D

class_name CameraController

@export var camera_bob: CameraMotionProfile;
@export var camera: Camera3D;
@export var weapon_socket_manager: WeaponSocketManager;
@export var weapon_base_position: Vector3;

var player_controller: PlayerController;
var time: float = 0;

func _process(delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("down", "up"));
	
	if(Input.is_action_pressed("sprint") && input_vector.y > 0):
		time += delta;
	elif(Input.is_action_just_released("sprint")):
		time = 0;
	else:
		time += delta / camera_bob.sprint_modifier;
		
	if(player_controller != null && player_controller.is_on_floor() && !player_controller.is_sliding && !player_controller.is_aiming):
		process_motion(input_vector, time, delta);
		camera.position.x = weapon_base_position.x;
		camera.position.z = weapon_base_position.z;
	elif(player_controller.is_aiming):
		camera.global_rotation.z = 0;
		camera.global_position = weapon_socket_manager.get_scope();

func process_motion(input_vector: Vector2, time: float, delta: float) -> void:
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -camera_bob.process_motion(camera, input_vector * Vector2(-1,1), time), delta * camera_bob.lean_speed);
