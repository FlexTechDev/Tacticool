extends Node3D

class_name SpawnPoint

enum Team{
	NEUTRAL,
	AI,
	RED,
	BLUE
}

@export var spawn_point_affiliation: Team = Team.NEUTRAL;
