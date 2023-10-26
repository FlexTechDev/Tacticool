extends Control

@export var environment: Environment;
@export var player_controller: PlayerController;
@export var player_animation_manager: AnimationManager;

func _ready() -> void:
	visible = false;

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("escape")):
		visible = !visible;

func set_sdfgi(value: bool) -> void:
	environment.sdfgi_enabled = value;

func set_ssao(value: bool) -> void:
	environment.ssao_enabled = value;

func set_ssr(value: bool) -> void:
	environment.ssr_enabled = value;

func look_x_changed(value_changed: float) -> void:
	player_controller.look_multiplier.x = value_changed;

func look_y_changed(value_changed: float) -> void:
	player_controller.look_multiplier.y = value_changed;

func fov_changed(value_changed: float) -> void:
	player_animation_manager.camera.fov = value_changed;
