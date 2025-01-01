extends CharacterBody3D

@export var boneAttachRightHand : NodePath;
@export var tree : NodePath;
@export var path_to_fireball : NodePath;
@export var path_to_fire_light : NodePath;
@export var Health = 2;
@export var ActiveOnStart = false;
@export var blood_hit_prefab : PackedScene;
@export var blood_explosion_prefab : PackedScene;
var currentFireballInstance;

var lastState = "";
var attackTimer = -1.0;
var dieTimer = 500.0;
var attackStep = -1;
signal OnDamage(amt : int, hitPos : Vector3);


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
	
	if Health > 0:
		dieTimer = 500.0;
	else:
		dieTimer -= delta;
		if dieTimer < 0.0:
			#TODO: Make blood explosion
			queue_free();

func damage(amt : int, sourcePos : Vector3):
	Health -= amt;
	if Health <= 0: #Previously set to a high value
		move_to_state("Die");
		dieTimer = 1.0;
	
	#TODO: Add blood splatter
	

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
			get_node(path_to_fireball).emitting = true;
			get_node(path_to_fire_light).visible = true;
	if attackStep == 1: #After we create the fireball and before we end aniumation
		if attackTimer <= 0.0:
			get_node(path_to_fireball).emitting = false;
			get_node(path_to_fire_light).visible = false;
			attackStep = -1;
			attackTimer = 0.2;
			move_to_state("Idle");
		return;
		
