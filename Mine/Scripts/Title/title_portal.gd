extends Area3D

@export var ChapterID = 1;
var SceneToGoTo = "";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Label3D").text = str("Chapter ", ChapterID);
	SceneToGoTo = "Mine/Scenes/Chapter1.tscn";
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	var player_body := body as XRToolsPlayerBody;
	if not player_body:
		return;
	
	var args : Array[String];
	args.append(SceneToGoTo);
	args.append("0.0, 0.0, 0.0");
	DialogueHandler.Instance.SteamTeleport(args)
