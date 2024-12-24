extends Node3D

@export var Dialogue1 : DialogueGrid;
@export var Dialogue2 : DialogueGrid;
@export var Particles : NodePath;
var pickedUp = false;

var waitForBrokenDialogue = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickedUp = false;
	waitForBrokenDialogue = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DialogueHandler.IsRunning == false:
		if waitForBrokenDialogue == true:
			print("Is running", DialogueHandler.IsRunning);
			DialogueHandler.Instance.StartDialogue(Dialogue2);
			waitForBrokenDialogue = false;


func _on_internet_pickup_grabbed(pickable: Variant, by: Variant) -> void:
	pickedUp = true;
	DialogueHandler.Instance.StartDialogue(Dialogue1);




func _on_xr_tools_pickable_body_entered(body: Node) -> void:
	if pickedUp == true:
		get_node(Particles).emitting = true;
		waitForBrokenDialogue = true;	
