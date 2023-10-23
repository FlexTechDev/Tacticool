extends Node3D

class_name AnimationManager

const WeaponType = {
	NoGun = "no_gun",
	AR15 = "AR15"
}

@export var tree: AnimationTree;
@export var playback_speed: float = 1;
@export var y_velocity_buffer: float = 0.1;
@export var camera: Camera3D;
@export var skeleton: Skeleton3D;
@export var look_ik_max_down_rotation: float = -15;
@export var look_ik_max_up_rotation: float = 35;
@export var enable_head_ik: bool = false;
@export var current_weapon = WeaponType.NoGun;

func _ready() -> void:
	set_weapon_type("AR15");

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
		tree.set("parameters/legs/moving/blend_position", lerp(tree.get("parameters/legs/moving/blend_position"), vector, 0.05));
		
		if(current_weapon == "no_gun"):
			tree.set("parameters/arms/no_gun/moving/blend_position", lerp(tree.get("parameters/arms/no_gun/moving/blend_position"), vector, 0.05));
		else:
			if(sprinting):
				tree.set("parameters/arms/" + current_weapon + "/conditions/sprinting", true);
			else:
				tree.set("parameters/arms/" + current_weapon + "/conditions/sprinting", false);
		
		set_falling(false);
	elif(abs(y_velocity) > y_velocity_buffer):
		playback_speed = 3;
		set_falling(true);

func set_sliding(value: bool) -> void:
	if(tree.get("parameters/legs/conditions/not_falling")):
		tree.set("parameters/legs/conditions/sliding", value);
		tree.set("parameters/legs/conditions/not_sliding", !value);
	if(current_weapon == "no_gun"):
		tree.set("parameters/arms/no_gun/conditions/sliding", value);
		tree.set("parameters/arms/no_gun/conditions/not_sliding", !value);
	else:
		pass

func set_falling(value: bool) -> void:
	tree.set("parameters/legs/conditions/falling", value);
	tree.set("parameters/legs/conditions/not_falling", !value);
	if(current_weapon == "no_gun"):
		tree.set("parameters/arms/no_gun/conditions/falling", value);
		tree.set("parameters/arms/no_gun/conditions/not_falling", !value);
	else:
		pass

func vault(dead_time: float) -> void:
	playback_speed = 3;
	tree.set("parameters/legs/conditions/vaulting", true);
	tree.set("parameters/legs/conditions/not_vaulting", false);
	if(current_weapon == "no_gun"):
		tree.set("parameters/arms/no_gun/conditions/vaulting", true);
		tree.set("parameters/arms/no_gun/conditions/not_vaulting", false);
	else:
		pass
	
	await get_tree().create_timer(dead_time).timeout;
	
	tree.set("parameters/legs/conditions/vaulting", false);
	tree.set("parameters/legs/conditions/not_vaulting", true);
	if(current_weapon == "no_gun"):
		tree.set("parameters/arms/no_gun/conditions/vaulting", false);
		tree.set("parameters/arms/no_gun/conditions/not_vaulting", true);
	else:
		pass

func process_head_ik() -> void:
	var bone_id: int = skeleton.find_bone("Gut");
	
	skeleton.set_bone_pose_rotation(bone_id, Quaternion.from_euler(Vector3(clamp(-camera.global_rotation.x, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation)),0,0)));
