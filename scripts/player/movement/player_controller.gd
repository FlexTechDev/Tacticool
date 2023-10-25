extends CharacterController

class_name PlayerController

@export var look_multiplier: Vector2 = Vector2(0.1, 0.1);
@export var arms: Node3D;

var time: float = 0;
var input_appended: bool = false;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	#camera look code
	if(event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var look_delta: Vector2 = event.relative;
		
		look_delta.x *= look_multiplier.x;
		look_delta.y *= look_multiplier.y;
		
		look_angle(-look_delta);
	
	#lock and unlock mouse
	if(event.is_action_pressed("escape") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	elif(event.is_action_pressed("escape") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _process(delta: float) -> void:
	var input_vector: Vector2 = Vector2(-Input.get_axis("left", "right"), Input.get_axis("down", "up"));
	
	#jumping, crouching and proning
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		jump();
	elif(Input.is_action_pressed("jump") && !is_on_floor() && try_vault() != Vector3.ZERO):
		current_vault_position = try_vault();
		append_movement_input(0.75);
		full_body_animation_manager.vault(0.75);
	elif(Input.is_action_pressed("prone") && !is_on_floor() && try_vault() != Vector3.ZERO):
		current_vault_position = Vector3.ZERO;
	
	#vaulting
	if(current_vault_position != null && current_vault_position != Vector3.ZERO):
		velocity = Vector3.ZERO;
		global_position = global_position.lerp(current_vault_position, delta * 3);
		
		if(global_position.distance_to(current_vault_position) <= vault_cutoff_point):
			current_vault_position = Vector3.ZERO;
		
	if(!input_appended):
		move(input_vector.rotated(-rotation.y), Input.is_action_pressed("sprint"), delta);
	
	#sliding code is here
	if(Input.is_action_pressed("sprint") && input_vector.y > 0):
		time += delta;
		if(Input.is_action_pressed("crouch") || Input.is_action_pressed("prone")):
			slide(delta);
			input_appended = true;
			full_body_animation_manager.set_sliding(true);
			time = 0;
		elif(Input.is_action_just_released("crouch") || Input.is_action_just_released("prone")):
			sliding_time = 0;
			input_appended = false;
	elif(Input.is_action_just_released("sprint")):
		time = 0;
	else:
		time += delta / movement_settings.sprint_magnifier;
	
	#sliding animation code is also here
	if(Input.is_action_just_released("crouch") || Input.is_action_just_released("prone")):
		full_body_animation_manager.set_sliding(false);
	
	#sprint speed for animations
	if(Input.is_action_pressed("sprint")):
		full_body_animation_manager.move(input_vector, velocity.y, true);
	else:
		full_body_animation_manager.move(input_vector / movement_settings.sprint_magnifier, velocity.y, true);
	move_and_slide();

func append_movement_input(time_in_seconds: float) -> void:
	#sets a timer and does not movement take input until timer is up
	input_appended = true;
	await get_tree().create_timer(time_in_seconds).timeout;
	input_appended = false;
	current_vault_position = Vector3.ZERO;
