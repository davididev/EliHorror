extends CharacterBody3D

@export var boneAttachRightHand : NodePath;
@export var tree : NodePath;
@export var path_to_fireball : NodePath;
@export var path_to_fire_light : NodePath;
@export var Health = 2;
@export var ActiveOnStart = false;
@export var dialogueOnDeath : DialogueGrid
var blood_hit_prefab : PackedScene = preload("res://Mine/Prefabs/Enemy/blood_spatter_1.tscn");
var blood_explosion_prefab : PackedScene = preload("res://Mine/Prefabs/Enemy/blood_explosion.tscn");
var currentFireballInstance;
var runSpeed = 0.0;
const MIN_SPEED = 2.5;
const MAX_SPEED = 6.0;
const ACCELERATION = 20.0;

var lastState = "";
var damageTimer = 0.0;
var attackTimer = -1.0;
var dieTimer = 500.0;
var attackStep = -1;
var firstKilled = true;
signal OnDamage(amt : int, hitPos : Vector3);


func SetActive(act : bool):
	visible = act;
	set_physics_process(act);
	set_process(act);
	get_node("CollisionShape3D").call_deferred("set_disabled", !act);

func _enter_tree() -> void:
	lastState = "";
	attackTimer = -1.0;
	attackStep = -1;
	firstKilled = true;
	#move_to_state("Idle");
	SetActive(ActiveOnStart);

#Move to state if not already in state
func move_to_state(state):
	if lastState == state:
		return;
	lastState = state;
	var state_machine = get_node(tree)["parameters/playback"]
	
	state_machine.travel(state);

func _process(delta: float) -> void:
	if visible == false:
		return;
	if damageTimer > 0.0:
		damageTimer -= delta;
	var myPos = global_position;
	var targetPos = PosVelCalc.HeadPos;
	targetPos.y = myPos.y;
	
	var dist = myPos.distance_to(targetPos);
	if dist < 1.5:
		run_attack_step(delta);
	else:
		if dist > 12.0:
			be_idle(delta);
		else:
			run_towards_player(delta, targetPos);
	if Health > 0:
		dieTimer = 500.0;
	else:
		dieTimer -= delta;
		if dieTimer < 0.0:
			#TODO: Make blood explosion
			var inst = blood_explosion_prefab.instantiate();
			inst.global_position = global_position;
			get_tree().root.add_child(inst);
			queue_free();
	move_and_slide();

func be_idle(delta : float):
	move_to_state("Idle");
	runSpeed = 0.0;
	velocity = Vector3(0.0, -1.0, 0.0);

func run_towards_player(delta : float, targetPos : Vector3):
	if Health <= 0:
		velocity = Vector3.ZERO;
		return;
	move_to_state("Run");
	runSpeed += ACCELERATION * delta;
	runSpeed = clamp(runSpeed, MIN_SPEED, MAX_SPEED);
	
	var col = get_node("CollisionShape3D/DemonMain");
	var look_at_node = get_node("LookAtTransofrm");
	look_at_node.look_at(targetPos, Vector3(0.0, 1.0, 0.0), true);
	var current_angle = col.rotation_degrees;
	current_angle.y = look_at_node.rotation_degrees.y;
	col.rotation_degrees = current_angle;
	velocity = col.global_basis.z * runSpeed;
	velocity.y = -1.0;
	
	
	

func damage(amt : int, sourcePos : Vector3):
	if damageTimer > 0.0:
		return;
	SoundFXPlayer.PlaySound("StabDemon.mp3", get_tree(), sourcePos, 5.0, 4.0);
	damageTimer = 0.05;
	Health -= amt;
	if Health <= 0 && firstKilled: #Previously set to a high value
		firstKilled = false;
		if dialogueOnDeath != null:
			DialogueHandler.Instance.StartDialogue(dialogueOnDeath);
		move_to_state("Die");
		dieTimer = 1.6;
	else:
		var inst = blood_hit_prefab.instantiate();
		inst.global_position = get_node("CollisionShape3D/DemonMain").global_position + Vector3(0.0, 1.0, 0.0);
		#inst.global_basis.z = get_node("CollisionShape3D/DemonMain").global_basis.z;
		inst.global_rotation_degrees = get_node("CollisionShape3D/DemonMain").global_rotation_degrees
		get_tree().root.add_child(inst);
	#TODO: Add blood splatter
	

func run_attack_step(delta : float):
	velocity = Vector3.ZERO;
	if Health <= 0:
		return;
	attackTimer -= delta;
	runSpeed = MIN_SPEED;
	if attackStep == -1:
		if attackTimer <= 0.0:
			move_to_state("Attack");
			attackStep = 0;	
			attackTimer = 0.5; #Before we set off the fireball
		return;
	if attackStep == 0: 
		if attackTimer <= 0.0:
			attackStep = 1;
			attackTimer = 1.5; #After we create the fireball and before we end aniumation
			get_node(path_to_fireball).emitting = true;
			get_node(path_to_fire_light).visible = true;
		return;
	if attackStep == 1: 
		if attackTimer <= 0.0:
			get_node(path_to_fireball).emitting = false;
			get_node(path_to_fire_light).visible = false;
			attackStep = -1;
			attackTimer = 0.5;
			move_to_state("Idle");
		return;
		
