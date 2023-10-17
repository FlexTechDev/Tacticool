extends CharacterController

@export var look_multiplier: Vector2 = Vector2(0.5, 0.5);
@export var camera_bob: CameraMotionProfile;
@export var camera: Camera3D;

var time: float = 0;
var input_appended: bool = false;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var look_delta: Vector2 = event.relative;
		
		look_delta.x *= look_multiplier.x;
		look_delta.y *= look_multiplier.y;
		
		look_angle(-look_delta);
	
	if(event.is_action_pressed("escape") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	elif(event.is_action_pressed("escape") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _process(delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"));
	
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		jump();
	elif(Input.is_action_pressed("jump") && !is_on_floor() && try_vault() != Vector3.ZERO):
		current_vault_position = try_vault();
		append_movement_input(0.75);
	elif(Input.is_action_pressed("prone") && !is_on_floor() && try_vault() != Vector3.ZERO):
		current_vault_position = Vector3.ZERO;
	
	if(current_vault_position != null && current_vault_position != Vector3.ZERO):
		velocity = Vector3.ZERO;
		global_position = global_position.lerp(current_vault_position, delta * 3);
		
		if(global_position.distance_to(current_vault_position) <= vault_cutoff_point):
			current_vault_position = Vector3.ZERO;
		
	if(!input_appended):
		move(input_vector.rotated(-rotation.y), Input.is_action_pressed("sprint"), delta);
	
	if(Input.is_action_pressed("sprint") && input_vector.y < 0):
		time += delta;
		if(Input.is_action_pressed("crouch") || Input.is_action_pressed("prone")):
			slide(delta);
			time = 0;
	elif(Input.is_action_just_released("sprint")):
		time = 0;
	else:
		time += delta / movement_settings.sprint_magnifier;
	
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -camera_bob.process_motion(camera, input_vector, time), delta * camera_bob.lean_speed);
	
	move_and_slide();

func append_movement_input(time_in_seconds: float) -> void:
	input_appended = true;
	await get_tree().create_timer(time_in_seconds).timeout;
	input_appended = false;
	current_vault_position = Vector3.ZERO;
