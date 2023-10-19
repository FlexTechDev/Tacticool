extends Node3D

class_name AnimationManager

@export var tree: AnimationTree;
@export var playback_speed: float = 1;
@export var y_velocity_buffer: float = 0.1;
@export var camera: Camera3D;
@export var skeleton: Skeleton3D;
@export var look_ik_max_down_rotation: float = -15;
@export var look_ik_max_up_rotation: float = 35;
@export var enable_head_ik: bool = false;

func _process(delta: float) -> void:
	if(enable_head_ik):
		process_head_ik()
	
	tree.advance(delta * playback_speed);

func move(vector: Vector2, y_velocity: float) -> void:
	if(abs(y_velocity) <= y_velocity_buffer):
		playback_speed = 3;
		tree.set("parameters/legs/grounded/blend_position", lerp(tree.get("parameters/legs/grounded/blend_position"), vector, 0.05));
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

func process_head_ik() -> void:
	var bone_id: int = skeleton.find_bone("Gut");
	
	skeleton.set_bone_pose_rotation(bone_id, Quaternion.from_euler(Vector3(clamp(-camera.global_rotation.x, deg_to_rad(look_ik_max_down_rotation), deg_to_rad(look_ik_max_up_rotation)),0,0)));
