extends Node

var peer: ENetMultiplayerPeer;
var is_host: bool;
var connected_players: Array[NetworkedPlayer];

func add_player(id: int) -> void:
	var player: NetworkedPlayer = NetworkedPlayer.new();
	
	player.id = id;
	
	connected_players.append(player);
