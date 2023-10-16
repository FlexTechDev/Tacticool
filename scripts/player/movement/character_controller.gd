extends CharacterBody3D

class_name CharacterController

@export var movement_settings: MovementProfile;
@export var camera_node: Node3D;
@export var vault_raycast: RayCast3D
@export var vault_cutoff_point: float = 0.3;

var last_movement_input_vector: Vector2
var is_sliding: bool = false
var sliding_time: float = 0;
var current_vault_position: Vector3;

func _physics_process(delta: float) -> void:
	if(!is_on_floor()):
		velocity.y -= movement_settings.gravity_scale;
		velocity.y = clamp(velocity.y, movement_settings.gravity, INF)
	elif(velocity.y < 0 && is_on_floor()):
		velocity.y = 0;

func move(vector: Vector2, is_sprinting: bool, delta: float) -> void:
	if(!is_sprinting):
		vector = vector.normalized();
	elif(is_sprinting):
		if(is_sliding && last_movement_input_vector != null):
			vector = last_movement_input_vector.normalized() * movement_settings.sprint_magnifier;
		else:
			sliding_time = 0;
			vector = vector.normalized() * movement_settings.sprint_magnifier;
	
	velocity.x = vector.x * movement_settings.speed * get_process_delta_time() * delta;
	velocity.z = vector.y * movement_settings.speed * get_process_delta_time() * delta;
	
	last_movement_input_vector = vector;
	
	is_sliding = false;

func try_vault() -> Vector3:
	if(vault_raycast.is_colliding() && vault_raycast.get_collision_normal() == Vector3(0, 1, 0)):
		velocity = Vector3.ZERO;
		return vault_raycast.get_collision_point();
	
	return Vector3.ZERO;

func slide(delta: float) -> void:
	is_sliding = true;
	
	velocity.x *= movement_settings.slide_speed_dropoff.sample(sliding_time);
	velocity.z *= movement_settings.slide_speed_dropoff.sample(sliding_time);
	
	sliding_time += delta;

func jump() -> void:
	velocity.y = movement_settings.jump_force;

func jump_with_custom_force(force: float) -> void:
	velocity.y = force;

func look_angle(angle_vector: Vector2) -> void:
	rotate_angle(angle_vector.x);
	
	if(camera_node != null):
		camera_node.rotation.x += deg_to_rad(angle_vector.y);

func look_to_angle(angle_vector: Vector2) -> void:
	rotate_to_angle(angle_vector.x);
	
	if(camera_node != null):
		camera_node.rotation.x = deg_to_rad(angle_vector.y);

func look_to_vector(vector: Vector3) -> void:
	#in the future, this will allow the unit to look in the direction of a vector
	pass

func rotate_angle(angle: float) -> void:
	rotation.y += deg_to_rad(angle);

func rotate_to_angle(angle: float) -> void:
	rotation.y = deg_to_rad(angle);
