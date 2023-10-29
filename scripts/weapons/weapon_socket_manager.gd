extends BoneAttachment3D

class_name WeaponSocketManager

@export var weapon_scenes: Array[WeaponPackage];

@export var current_weapon: String;

func _ready() -> void:
	load_weapon(current_weapon);

func change_weapon(weapon: String) -> void:
	current_weapon = weapon;
	
	load_weapon(current_weapon);

func load_weapon(current_weapon: String) -> void:
	if(get_child(0) != null):
		get_child(0).queue_free();
	
	var scene: PackedScene = get_scene(current_weapon);
	
	if(scene != null):
		var scene_instance: Node3D = scene.instantiate();
		add_child(scene_instance);

func get_scene(weapon: String) -> PackedScene:
	for scene in weapon_scenes:
		if(scene.weapon == weapon):
			return scene.scene;
	
	return null;

func get_scope() -> Vector3:
	return get_child(0).camera_scope.global_position;
