extends Control

class_name MainMenuManager

enum GameMode
{
	MULTIPLAYER,
	GAMEPLAY_TESTING
}

@export var gameplay_testing_scene: PackedScene;

@export var game_mode_panel: GameModePanel;
@export var game_mode_label: Button;

var current_game_mode: GameMode = GameMode.GAMEPLAY_TESTING;

func _ready() -> void:
	update_game_mode_ui();

func update_game_mode_ui() -> void:
	if(current_game_mode == GameMode.MULTIPLAYER):
		game_mode_label.text = "Multiplayer"
	elif(current_game_mode == GameMode.GAMEPLAY_TESTING):
		game_mode_label.text = "Testing"

func change_game_mode() -> void:
	game_mode_panel.visible = true;

func set_game_mode(mode: GameMode) -> void:
	current_game_mode = mode;
	update_game_mode_ui();


func play() -> void:
	if(current_game_mode == GameMode.GAMEPLAY_TESTING):
		get_tree().change_scene_to_packed(gameplay_testing_scene);
	else:
		print("not yet an implemented game mode");
