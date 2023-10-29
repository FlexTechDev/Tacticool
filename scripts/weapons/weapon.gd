extends Node3D

class_name Weapon

@export var position_offset: Vector3;
@export var rotation_offset: Vector3;

func _ready() -> void:
	position = position_offset;
	rotation_degrees = rotation_offset;

func shoot(point: Vector3) -> void:
	pass

func melee() -> void:
	pass 
