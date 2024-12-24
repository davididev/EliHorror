extends Control

@export var Panels : Array[NodePath];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetPanel(0);


func SetPanel(id : int):
	for i in range(0, Panels.size()):
		get_node(Panels[i]).visible = (id == i);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_button_pressed() -> void:
	SetPanel(1);
