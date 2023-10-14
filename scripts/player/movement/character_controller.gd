extends CharacterBody3D

class_name CharacterController

@export var movement_settings: MovementProfile;
@export var camera: Camera3D;

func _physics_process(delta: float) -> void:
	if(!is_on_floor()):
		velocity.y -= movement_settings.gravity_scale;
		velocity.y = clamp(velocity.y, movement_settings.gravity, INF)
	elif(velocity.y < 0 && is_on_floor()):
		velocity.y = 0;

func move(vector: Vector2, is_sprinting: bool) -> void:
	if(!is_sprinting):
		vector = vector.normalized();
	elif(is_sprinting):
		vector = vector.normalized() * movement_settings.sprint_magnifier;
	
	velocity.x = vector.x * movement_settings.speed * get_process_delta_time();
	velocity.z = vector.y * movement_settings.speed * get_process_delta_time();

func jump() -> void:
	velocity.y = movement_settings.jump_force;

func jump_with_custom_force(force: float) -> void:
	velocity.y = force;

func look_angle(angle_vector: Vector2) -> void:
	rotate_angle(angle_vector.x);
	
	if(camera != null):
		camera.rotation.x += deg_to_rad(angle_vector.y);

func look_to_angle(angle_vector: Vector2) -> void:
	rotate_to_angle(angle_vector.x);
	
	if(camera != null):
		camera.rotation.x = deg_to_rad(angle_vector.y);

func look_to_vector(vector: Vector3) -> void:
	#in the future, this will allow the unit to look in the direction of a vector
	pass

func rotate_angle(angle: float) -> void:
	rotation.y += deg_to_rad(angle);

func rotate_to_angle(angle: float) -> void:
	rotation.y = deg_to_rad(angle);
