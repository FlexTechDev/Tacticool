extends Node

class_name MultiplayerGameManager

@export var spawn_points: Array[SpawnPoint];

var online_players: Array[NetworkedPlayer];

func _ready() -> void:
	spawn_points = get_all_spawn_points();

func get_all_spawn_points() -> Array[SpawnPoint]:
	var children: Array[Node] = get_children();
	var return_children: Array[SpawnPoint] = [];
	
	for child in children:
		if(child is SpawnPoint):
			return_children.append(child);
	
	return return_children;

func get_random_spawn_point_of_type(team: SpawnPoint.Team) -> SpawnPoint:
	spawn_points.shuffle();
	
	for spawn_point in spawn_points:
		if(spawn_point.team == team):
			return spawn_point;
	
	return null;

func get_player(id: int) -> NetworkedPlayer:
	for player in online_players:
		if(player.id == id):
			return player;
	
	return null;

func spawn_player(id: int) -> void:
	if(is_valid_player(id)):
		var spawn_point: SpawnPoint = get_random_spawn_point_of_type(get_player(id).team);
		print(spawn_point.spawn_point_affiliation);

func is_valid_player(id: int) -> bool:
	for player in online_players:
		if(player.id == id):
			return true;
	
	return false;
