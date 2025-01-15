extends RigidBody3D

signal OnDamage(amt : int, hitPos : Vector3);
@export var root_path : NodePath;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_on_damage(amt: int, hitPos: Vector3) -> void:
	get_node(root_path).call("DamageTeleporter")
