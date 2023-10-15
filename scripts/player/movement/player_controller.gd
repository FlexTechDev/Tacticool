extends CharacterController

@export var look_multiplier = 0.1;
@export var camera_bob: CameraMotionProfile;
@export var camera: Camera3D;

var time: float = 0;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var look_delta: Vector2 = event.relative * look_multiplier;
		
		look_angle(-look_delta);
	
	if(event.is_action_pressed("escape") && Input.mouse_mode ==Input.MOUSE_MODE_CAPTURED):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	elif(event.is_action_pressed("escape") && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _process(delta: float) -> void:
	var input_vector: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"));
	
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		jump();
	
	move(input_vector.rotated(-rotation.y), Input.is_action_pressed("sprint"));
	
	if(Input.is_action_pressed("sprint")):
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
