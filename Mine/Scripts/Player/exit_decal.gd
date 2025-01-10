extends Area3D

@export var NextScene = "Mine/Scenes/Chapter3.tscn";
@export var FailureDialogue : DialogueGrid;

var failureTimer = 0.0;
var changingScene = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	failureTimer = 0.0;
	changingScene = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if failureTimer > 0.0:
		failureTimer -= delta;


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player_body"):
		return
	if changingScene == true:
		return;
	
	if SceneVars.KeyCollected:  #Move on to next scene
		var args : Array[String];
		args.append(NextScene);
		args.append("0,0,0");
		DialogueHandler.Instance.SteamTeleport(args, true);
		changingScene = true;
	else: #Don't have the keycard yet
		if failureTimer <= 0.0:
			DialogueHandler.Instance.StartDialogue(FailureDialogue);
			failureTimer = 10.0;
