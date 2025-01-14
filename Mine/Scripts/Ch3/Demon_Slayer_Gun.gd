extends Node3D

@export var path_of_glow : NodePath;
@export var path_of_gun_fire : NodePath;
@export var FireSound : String = "Shoot.mp3"
const START_GLOW_STRENGTH = 10.0;
const END_GLOW_STRENGTH = 1.0;
const CHARGE_TIME = 2.0;
const DAMAGE = 6;
var currentChargeTimer = 0.0;

var currentFireFresnel = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_node(path_of_gun_fire).visible = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentChargeTimer += delta;
	if currentChargeTimer > CHARGE_TIME:
		currentChargeTimer = CHARGE_TIME;
	
	var perc = currentChargeTimer / CHARGE_TIME;
	var vs = get_node(path_of_glow).get_surface_override_material(0) as ShaderMaterial;
	vs.set_shader_parameter("PowerValue", lerp(START_GLOW_STRENGTH, END_GLOW_STRENGTH, perc));
	if get_node(path_of_gun_fire).visible == true:
		currentFireFresnel += 5.0 * delta;
		if currentFireFresnel >= 15.0:
			get_node(path_of_gun_fire).visible = false;
		else:
			var vs2 = get_node(path_of_gun_fire).get_surface_override_material(0) as ShaderMaterial;
			vs2.set_shader_parameter("FloatParameter", currentFireFresnel);

func _on_pickable_object_action_pressed(pickable: Variant) -> void:
	if is_equal_approx(currentChargeTimer, CHARGE_TIME):  #Gun has finished charging, create a 
		currentChargeTimer = 0.0;
		var space_state = get_world_3d().direct_space_state;
		
		var origin = get_node(path_of_gun_fire).global_position;
		var end = origin + (get_node(path_of_gun_fire).global_basis.z * -100.0)
		var lm = pow(2, 1-1) + pow(2, 6-1); #Static and enemy layer
		var query = PhysicsRayQueryParameters3D.create(origin, end, lm)
		query.collide_with_bodies = true;
		
		var result = space_state.intersect_ray(query)
		if result.is_empty() == false:
			#end = result.position;
			
			SoundFXPlayer.PlaySound(FireSound, get_tree(), origin, 5.0, 2.0);
			var s = origin.distance_to(result.position)
			get_node(path_of_gun_fire).scale = Vector3(1.0, s, 1.0);
			print("Pos: ", result.position, "s: ", s);
			get_node(path_of_gun_fire).visible = true;
			currentFireFresnel = 1.0;
			print(result.collider.name);
			if result.collider != null:
				if result.collider.has_signal("OnDamage"):
					result.collider.emit_signal("OnDamage", DAMAGE);
