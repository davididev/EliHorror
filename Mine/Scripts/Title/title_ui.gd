extends Control

@export var panels : Array[NodePath];
@export var scenes : Array[String];
var lastID = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetPanel(0);
	
func SetPanel(id : int):
	if id >= panels.size():
		id = 0;
	if id < 0:
		id = panels.size() - 1;
	lastID = id;
	
	for i in range(0, panels.size()):
		get_node(panels[i]).visible = (id == i);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_prev_button_pressed() -> void:
	SetPanel(lastID - 1);


func _on_next_button_pressed() -> void:
	SetPanel(lastID + 1);

func LoadScene(id : int):
	var args : Array[String];
	args.append(scenes[id]);
	args.append("0.0, 0.0, 0.0");
	DialogueHandler.Instance.SteamTeleport(args, true);
	visible = false;

func _on_panel_button_1_pressed() -> void:
	LoadScene(0);


func _on_panel_button_2_pressed() -> void:
	LoadScene(1);


func _on_panel_button_3_pressed() -> void:
	LoadScene(2);


func _on_panel_button_4_pressed() -> void:
	LoadScene(3);


func _on_panel_button_5_pressed() -> void:
	LoadScene(4);
