extends Area3D

@export var Damage = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player_body"):
		return
	if not get_node("CollisionShape3D/GPUParticles3D").emitting:
		return;
		
	body.emit_signal("OnDamage", Damage, global_position);
