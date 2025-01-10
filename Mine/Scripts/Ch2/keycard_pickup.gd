extends Node3D

@export var dialogue : DialogueGrid;
var waitToHideTimer = 250000.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	waitToHideTimer = 250000.0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible == false:
		return;
	waitToHideTimer -= delta;
	if waitToHideTimer <= 0.0:
		visible = false;


func _on_pickable_object_grabbed(pickable: Variant, by: Variant) -> void:
	if visible == false:
		return;
	if SceneVars.KeyCollected == true:
		return;
	SceneVars.KeyCollected = true;
	DialogueHandler.Instance.StartDialogue(dialogue);
	waitToHideTimer = 1.0;
