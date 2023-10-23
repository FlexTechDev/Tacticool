extends Control

class_name GameModePanel

@export var main_menu: MainMenuManager

func set_game_mode_multiplayer() -> void:
	main_menu.set_game_mode(main_menu.GameMode.MULTIPLAYER);
	visible = false;

func set_game_mode_gameplay_testing() -> void:
	main_menu.set_game_mode(main_menu.GameMode.GAMEPLAY_TESTING);
	visible = false;
