extends CharacterBody3D

@export var boneAttachRightHand : NodePath;
@export var tree : NodePath;
@export var Health = 2;
@export var ActiveOnStart = false;
@export var fireball_prefab : PackedScene;
var currentFireballInstance;

var lastState = "";
var attackTimer = -1.0;
var attackStep = -1;


func SetActive(act : bool):
	visible = act;
	set_physics_process(act);

func _init() -> void:
	lastState = "";
	attackTimer = -1.0;
	attackStep = -1;
	move_to_state("Idle");
	SetActive(ActiveOnStart);

#Move to state if not already in state
func move_to_state(state):
	if lastState == state:
		return;
	lastState = state;
	get_node(tree).travel(state);

func _process(delta: float) -> void:
	if visible == false:
		return;
	var myPos = global_position;
	var targetPos = PosVelCalc.HeadPos;
	targetPos.y = myPos.y;
	
	var dist = myPos.distance_to(targetPos);
	if dist < 2.0:
		run_attack_step(delta);
			

func run_attack_step(delta : float):
	attackTimer -= delta;
	if attackStep == -1:
		if attackTimer <= 0.0:
			move_to_state("Attack");
			attackStep = 0;	
			attackTimer = 1.0;
		return;
	if attackStep == 0: #Before we set off the fireball
		if attackTimer <= 0.0:
			attackStep = 1;
			attackTimer = 2.0;
			currentFireballInstance = fireball_prefab.instantiate();
			get_node(boneAttachRightHand).add_child(currentFireballInstance);
			
	if attackStep == 1: #After we create the fireball and before we end aniumation
		if attackTimer <= 0.0:
			get_node(boneAttachRightHand).remove_child(currentFireballInstance);
			attackStep = -1;
			attackTimer = 0.2;
			move_to_state("Idle");
		return;
		
