class_name SoundFXPlayer extends Node3D

@export var ref : NodePath;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func PlaySound(file_name : String, t : SceneTree, pos : Vector3, minDistance : float = 5.0, maxDistanceMultiplier : float = 4.0):
	var instance : SoundFXPlayer = ResourceLoader.load("res://VR/Scripts/Audio/sound_fx_player.tscn").instantiate(); 
	t.root.add_child(instance);
	instance.global_position = pos;
	var asset_name : String = str("res://Audio/Sound/", file_name);
	instance.get_node(instance.ref).unit_size = minDistance;
	instance.get_node(instance.ref).max_distance = minDistance * maxDistanceMultiplier;
	instance.get_node(instance.ref).stream = load(asset_name);
	instance.get_node(instance.ref).play();
	instance.play_sound_routine();

func play_sound_routine():
	await get_tree().create_timer(0.05).timeout;
	while get_node(ref).playing == true:
		await get_tree().create_timer(0.05).timeout;
	
	queue_free();
