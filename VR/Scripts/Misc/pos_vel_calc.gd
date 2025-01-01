class_name PosVelCalc extends Node3D

var damageTimer = -1.0;
const DAMAGE_DELAY = 0.5;
static var LeftHandPos : Vector3;
static var RightHandPos : Vector3;
static var HeadPos : Vector3;
static var LeftHandVel : Vector3;
static var RightHandVel : Vector3;
static var HeadVel : Vector3;

var _last_left_hand_position : Vector3;
var _last_right_hand_position : Vector3;
var _last_head_position : Vector3;


var blood_hit_prefab : PackedScene = preload("res://Mine/Prefabs/Enemy/blood_spatter_1.tscn");
@export var LeftHandRef : NodePath;
@export var RightHandRef : NodePath;
@export var HeadRef : NodePath;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	LeftHandPos = get_node(LeftHandRef).global_position;
	RightHandPos  = get_node(RightHandRef).global_position;
	HeadPos = get_node(HeadRef).global_position;
	LeftHandVel = abs((_last_left_hand_position - get_node(LeftHandRef).position)) / delta;
	RightHandVel = abs((_last_right_hand_position - get_node(RightHandRef).position)) / delta;
	HeadVel = abs((_last_head_position - get_node(HeadRef).position)) / delta;
	
	
	_last_left_hand_position = get_node(LeftHandRef).position;
	_last_right_hand_position = get_node(RightHandRef).position
	_last_head_position = get_node(HeadRef).position;
	if damageTimer > 0.0:
		damageTimer -= delta;

func _on_player_body_on_damage(amt: int, hitPos: Vector3) -> void:
	if damageTimer > 0.0:
		return;
	SceneVars.CurrentHealth -= amt;
	damageTimer = DAMAGE_DELAY;
	var inst = blood_hit_prefab.instantiate();
	get_tree().root.add_child(inst);
	inst.global_position = hitPos;
	inst.global_basis.z = get_node(HeadRef).global_basis.z;
	
