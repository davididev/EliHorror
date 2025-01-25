extends Node3D

@export var Mesh_Path : NodePath;
@export var Rigid_Path : NodePath;

var currentMeshPoint = -1;
const BLEND_SHAPE_PER_SECOND = 2.0;

signal Open();



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentMeshPoint == -1:  ##Jiggle value so it responds to lighting
		var value = get_node(Mesh_Path).get_blend_shape_value(currentMeshPoint)
		if is_zero_approx(value):
			value = 0.01;
		else:
			value = 0.00;
		get_node(Mesh_Path).set_blend_shape_value(0, value);
	if currentMeshPoint > -1:
		var value = get_node(Mesh_Path).get_blend_shape_value(currentMeshPoint)
		value = move_toward(value, 1.0, BLEND_SHAPE_PER_SECOND * delta);
		get_node(Mesh_Path).set_blend_shape_value(currentMeshPoint, value);
		if is_equal_approx(value, 1.0):  #Bump is done being created, move stop processing blend shapes
			currentMeshPoint = -1;


func _on_open() -> void:
	currentMeshPoint = 0;
	await get_tree().create_timer(1.9).timeout;
	currentMeshPoint = 1;
	await get_tree().create_timer(1.9).timeout;
	currentMeshPoint = 2;
	await get_tree().create_timer(1.9).timeout;
	
	get_node(Rigid_Path).freeze = false;
	var impulse = Vector3(90.0, 5.0, 0.0);
	get_node(Rigid_Path).apply_impulse(impulse);


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	if not body.is_in_group("player_body"):
		return
	
	if get_node(Rigid_Path).linear_velocity.length() > 1.0:  #Moving fast enough to do real damage
		body.emit_signal("OnDamage", 70, global_position);
