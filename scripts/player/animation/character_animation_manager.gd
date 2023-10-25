extends Node3D

class_name AnimationManager

const WeaponType = {
	NoGun = "no_gun",
	AR15 = "AR15"
}

@export var look_multiplier: Vector2 = Vector2(0.1, 0.1);
@export var tree: AnimationTree;
@export var playback_speed: float = 3;
@export var y_velocity_buffer: float = 0.1;
@export var camera: Camera3D;
@export var skeleton: Skeleton3D;
@export var look_ik_max_down_rotation: float = -15;
@export var look_ik_max_up_rotation: float = 35;
@export var enable_head_ik: bool = true;
@export var current_weapon = WeaponType.NoGun;

var look_angle: float = 0;

func _ready() -> void:
	set_weapon_type("AR15");

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		look_angle = event.relative.y * look_multiplier.y;

func set_weapon_type(type: String) -> void:
	for t in WeaponType:
		if(t == type):
			tree.set("parameters/arms/conditions/" + str(t), true)
		else:
			tree.set("parameters/arms/conditions/" + str(t), false)

func _process(delta: float) -> void:
	if(enable_head_ik):
		process_head_ik()
	
	tree.advance(delta * playback_speed);

func move(vector: Vector2, y_velocity: float, sprinting: bool) -> void:
	if(abs(y_velocity) <= y_velocity_buffer):
		playback_speed = 3;
		vector.x *= -1;
		tree.set("parameters/legs/moving/blend_position", lerp(tree.get("parameters/legs/moving/blend_position"), vector, 0.05));
		
		set_falling(false);
	elif(abs(y_velocity) > y_velocity_buffer):
		playback_speed = 3;
		set_falling(true);

func set_sliding(value: bool) -> void:
	if(tree.get("parameters/legs/conditions/not_falling")):
		tree.set("parameters/legs/conditions/sliding", value);
		tree.set("parameters/legs/conditions/not_sliding", !value);

func set_falling(value: bool) -> void:
	tree.set("parameters/legs/conditions/falling", value);
	tree.set("parameters/legs/conditions/not_falling", !value);

func vault(dead_time: float) -> void:
	playback_speed = 3;
	tree.set("parameters/legs/conditions/vaulting", true);
	tree.set("parameters/legs/conditions/not_vaulting", false);
	
	await get_tree().create_timer(dead_time).timeout;
	
	tree.set("parameters/legs/conditions/vaulting", false);
	tree.set("parameters/legs/conditions/not_vaulting", true);

func process_head_ik() -> void:
	var bone_id: int = skeleton.find_bone("Gut");
	
	skeleton.set_bone_pose_rotation(bone_id, Quaternion.from_euler(Vector3(clamp(look_angle, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation)),0,0)));
