extends Node3D

@export var Demon_Ref : NodePath;
@export var dialogue_on_grab : DialogueGrid
@export var TouchDamage = 1;
var initial_pickup = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pickup = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickable_object_picked_up(pickable: Variant) -> void:
	if initial_pickup == true:
		return;
	initial_pickup = true;
	DialogueHandler.Instance.StartDialogue(dialogue_on_grab);
	get_node(Demon_Ref).call("SetActive", true);
	await get_tree().create_timer(0.25).timeout;
	PlayMusic.PlaySong("LetsPlay.mp3");


func _on_pickable_object_body_entered(body: Node3D) -> void:
	if body.is_in_group("Damagable"):
		if body.has_signal("OnDamage"):
			body.emit_signal("OnDamage", TouchDamage, get_node("PickableObject/BladePoint").global_position);
