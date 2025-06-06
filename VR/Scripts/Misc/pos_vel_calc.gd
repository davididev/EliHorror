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
#request_jump

@export var LeftHandRef : NodePath;
@export var RightHandRef : NodePath;
@export var HeadRef : NodePath;
@export var BodyRef : NodePath;

var _controller1;
var _controller2;

var body : XRToolsPlayerBody
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body = get_node(BodyRef) as XRToolsPlayerBody;
	_controller1 = XRHelpers.get_xr_controller(get_node(LeftHandRef))
	_controller2 = XRHelpers.get_xr_controller(get_node(RightHandRef))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _controller1.get_is_active() and _controller2.get_is_active():
		if _controller1.get_float("trigger") > 0.9 and _controller1.get_float("grip") < 0.5:
			if _controller2.get_float("trigger") > 0.9 and _controller2.get_float("grip") < 0.5:
				body.calibrate_player_height()
	
	LeftHandPos = get_node(LeftHandRef).global_position;
	RightHandPos  = get_node(RightHandRef).global_position;
	HeadPos = get_node(HeadRef).global_position;
	LeftHandVel = abs((_last_left_hand_position - get_node(LeftHandRef).position)) / delta;
	RightHandVel = abs((_last_right_hand_position - get_node(RightHandRef).position)) / delta;
	HeadVel = abs((_last_head_position - get_node(HeadRef).position)) / delta;
	
	
	_last_left_hand_position = get_node(LeftHandRef).position;
	_last_right_hand_position = get_node(RightHandRef).position
	_last_head_position = get_node(HeadRef).position;
