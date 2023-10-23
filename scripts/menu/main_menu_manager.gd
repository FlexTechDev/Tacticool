extends Control

class_name MainMenuManager

enum GameMode
{
	MULTIPLAYER,
	GAMEPLAY_TESTING
}

@export var gameplay_testing_scene: PackedScene;
@export var multiplayer_testing_scene: PackedScene;
@export var game_mode_panel: GameModePanel;
@export var game_mode_label: Button;

var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new();
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

func join_random_game() -> void:
	multiplayer_peer.create_client("127.0.0.1", 123);
	GlobalMultiplayerManager.peer = multiplayer_peer;
	GlobalMultiplayerManager.add_player(multiplayer_peer.get_unique_id());

func create_game() -> void:
	multiplayer_peer.create_server(123);
	GlobalMultiplayerManager.peer = multiplayer_peer;
	GlobalMultiplayerManager.is_host = true;
	GlobalMultiplayerManager.add_player(multiplayer_peer.get_unique_id());

func play() -> void:
	if(current_game_mode == GameMode.GAMEPLAY_TESTING):
		get_tree().change_scene_to_packed(gameplay_testing_scene);
	elif(current_game_mode == GameMode.MULTIPLAYER):
		create_game();
		
		get_tree().change_scene_to_packed(multiplayer_testing_scene);
	else:
		print("not yet an implemented game mode");
