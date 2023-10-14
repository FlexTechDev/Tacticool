extends CharacterController

@export var look_multiplier = 0.1;

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
	
	move_and_slide();
