extends Node3D

var hitpoints = 60;
var spawnTimer = 0.0;
const SPAWN_TIME = 10.0;
const MAX_HP = 60;

@export var particle_burst_damage_path : NodePath;
@export var particle_burst_teleport_path : NodePath;
@export var demon_prefab : PackedScene;
@export var explosion_prefab : PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitpoints = MAX_HP;
	spawnTimer = 1.0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawnTimer -= delta;
	if spawnTimer <= 0.0:
		var inst = demon_prefab.instantiate();
		inst.global_position = global_position + Vector3(0.0, 1.0, 0.0);
		add_child(inst);
		spawnTimer = SPAWN_TIME;
		SoundFXPlayer.PlaySound("Teleport.mp3", get_tree(), global_position, 8.0, 10.0);
		get_node(particle_burst_teleport_path).emitting = true;

func DamageTeleporter():
	hitpoints -= 1;
	get_node(particle_burst_damage_path).emitting = true;
	if hitpoints <= 0:
		var inst = explosion_prefab.instantiate();
		inst.global_position = global_position + Vector3(0.0, 1.0, 0.0);
		get_tree().root.add_child(inst);
		visible = false;
		get_tree().create_timer(2.0).timeout;
		var args : Array[String];
		args.append("Mine/Scenes/Ch1/Epilogue.tscn");
		args.append("0,0,0");
		DialogueHandler.Instance.SteamTeleport(args, true)
