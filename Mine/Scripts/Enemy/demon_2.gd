extends CharacterBody3D

var blood_hit_prefab : PackedScene = preload("res://Mine/Prefabs/Enemy/blood_spatter_1.tscn");
var blood_explosion_prefab : PackedScene = preload("res://Mine/Prefabs/Enemy/blood_explosion.tscn");
@export var tree : NodePath;

signal OnDamage(amt : int, hitPos : Vector3);
var damage_timer = 1.0;

var lastState = "";

func _ready() -> void:
	damage_timer = 1.0;
	move_to_state("Stagger_Idle");

func move_to_state(state):
	if lastState == state:
		return;
	lastState = state;
	var state_machine = get_node(tree)["parameters/playback"]
	
	state_machine.travel(state);

func _process(delta: float) -> void:
	if damage_timer > 0.0:
		damage_timer -= delta;
		


func _on_on_damage(amt: int, hitPos: Vector3) -> void:
	if damage_timer > 0.0:
		return;
		
	move_to_state("Die");
	await get_tree().create_timer(1.6).timeout;
	var inst = blood_explosion_prefab.instantiate();
	inst.global_position = global_position;
	get_tree().root.add_child(inst);
	queue_free();
