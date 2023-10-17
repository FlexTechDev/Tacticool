extends Control

@export var environment: Environment;
@export var player: CharacterBody3D;

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
	player.look_multiplier.x = value_changed;

func look_y_changed(value_changed: float) -> void:
	player.look_multiplier.y = value_changed;
