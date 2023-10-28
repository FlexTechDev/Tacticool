extends Node3D

class_name AnimationManager

const WeaponType = {
	NoGun = "no_gun",
	AR15 = "AR15"
}

@export var look_multiplier: Vector2 = Vector2(0.1, 0.001);
@export var tree: AnimationTree;
@export var playback_speed: float = 3;
@export var y_velocity_buffer: float = 0.1;
@export var camera: Camera3D;
@export var skeleton: Skeleton3D;
@export var look_ik_max_down_rotation: float = -45;
@export var look_ik_max_up_rotation: float = 45;
@export var enable_head_ik: bool = true;
@export var current_weapon = WeaponType.NoGun;
@export var camera_controller: CameraController;
@export var weapon_lerp_time: float = 8;

var player_controller: PlayerController;
var look_angle: float = 0;

func _ready() -> void:
	set_weapon_type("AR15");

func set_player_controller() -> void:
	camera_controller.player_controller = player_controller;

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		look_angle += event.relative.y * look_multiplier.y;
		look_angle = clamp(look_angle, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation));

func set_weapon_type(type: String) -> void:
	current_weapon = type;
	for t in WeaponType:
		if(t == type):
			tree.set("parameters/transitions/current_state", str(t))
		else:
			tree.set("parameters/transitions/current_state", str(t))

func _process(delta: float) -> void:
	tree.advance(delta * playback_speed);
	
	if(enable_head_ik):
		process_head_ik()

func move(vector: Vector2, y_velocity: float, sprinting: bool) -> void:
	if(abs(y_velocity) <= y_velocity_buffer):
		playback_speed = 3;
		vector.x *= -1;
		tree.set("parameters/legs/moving/blend_position", lerp(tree.get("parameters/legs/moving/blend_position"), vector, 0.05));
		tree.set("parameters/" + str(current_weapon) + "/moving/blend_position", lerp(tree.get("parameters/" + str(current_weapon) + "/moving/blend_position"), vector, 0.05));
		
		set_falling(false);
	elif(abs(y_velocity) > y_velocity_buffer):
		playback_speed = 3;
		set_falling(true);

func set_sliding(value: bool) -> void:
	if(tree.get("parameters/legs/conditions/not_falling")):
		tree.set("parameters/legs/conditions/sliding", value);
		tree.set("parameters/legs/conditions/not_sliding", !value);
	
	if(tree.get("parameters/" + str(current_weapon) + "/conditions/not_falling")):
		tree.set("parameters/" + str(current_weapon) + "/conditions/sliding", value);
		tree.set("parameters/" + str(current_weapon) + "/conditions/not_sliding", !value);

func set_falling(value: bool) -> void:
	tree.set("parameters/legs/conditions/falling", value);
	tree.set("parameters/legs/conditions/not_falling", !value);
	
	tree.set("parameters/" + str(current_weapon) + "/conditions/falling", value);
	tree.set("parameters/" + str(current_weapon) + "/conditions/not_falling", !value);

func vault(dead_time: float) -> void:
	playback_speed = 3;
	tree.set("parameters/legs/conditions/vaulting", true);
	tree.set("parameters/legs/conditions/not_vaulting", false);
	
	tree.set("parameters/" + str(current_weapon) + "/conditions/vaulting", true);
	tree.set("parameters/" + str(current_weapon) + "/conditions/not_vaulting", false);
	
	await get_tree().create_timer(dead_time).timeout;
	
	tree.set("parameters/legs/conditions/vaulting", false);
	tree.set("parameters/legs/conditions/not_vaulting", true);
	
	tree.set("parameters/" + str(current_weapon) + "/conditions/vaulting", false);
	tree.set("parameters/" + str(current_weapon) + "/conditions/not_vaulting", true);

func process_head_ik() -> void:
	var gut_bone_id: int = skeleton.find_bone("Gut");
	var chest_bone_id: int = skeleton.find_bone("Chest");
	
	skeleton.set_bone_pose_rotation(gut_bone_id, Quaternion.from_euler(Vector3(clamp(look_angle, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation)),0,0)));
	skeleton.set_bone_pose_rotation(chest_bone_id, Quaternion.from_euler(Vector3(clamp(look_angle, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation)),0,0)));
