class_name PosVelCalc extends Node3D

static var LeftHandPos : Vector3;
static var RightHandPos : Vector3;
static var HeadPos : Vector3;
static var LeftHandVel : Vector3;
static var RightHandVel : Vector3;
static var HeadVel : Vector3;

var _last_left_hand_position : Vector3;
var _last_right_hand_position : Vector3;
var _last_head_position : Vector3;


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
