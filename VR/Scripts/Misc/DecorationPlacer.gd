@tool
class_name DecorationPlacer
extends Node3D

@export var MyList : Array[DecorationResource]
@export var selected : bool = false;
var lastPressed : bool = false;
var eds

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	global_position = Vector3(0.0, 0.0, 0.0)
	global_rotation_degrees = Vector3(0.0, 0.0, 0.0)
	set_process_input(true)
	print("Created decoration placer")
	

func calculate_rotation_from_normal(normal: Vector3) -> Vector3:
	# Assuming the normal is already a unit vector
	# Calculate the rotation needed to align the object with the normal
	# This is a simplified example; you might need to adjust based on your specific requirements
	var up_vector = Vector3.UP
	var right_vector = up_vector.cross(normal).normalized()
	var forward_vector = normal.cross(right_vector).normalized()
	
	# Convert the vectors to Euler angles
	var euler_angles = Vector3()
	euler_angles.x = atan2(forward_vector.y, forward_vector.z)
	euler_angles.y = atan2(-forward_vector.x, sqrt(forward_vector.y * forward_vector.y + forward_vector.z * forward_vector.z))
	euler_angles.z = atan2(right_vector.y, right_vector.x)
	return euler_angles
	
	
func _on_click():
	#global_position = Vector3(0.0, 0.0, 0.0)
	global_position = Vector3(0.0, 0.0, 0.0)
	global_rotation_degrees = Vector3(0.0, 0.0, 0.0)
	scale = Vector3.ONE
	top_level = true;  #don't know why this is necessary but it seems to be
	var id = _pick_prefab()
	var prefab : PackedScene = MyList[id].Prefab
	
	
	#Get raycast position from editor
	var camera_3d = EditorInterface.get_editor_viewport_3d(0).get_camera_3d();
	var mousePos =  EditorInterface.get_editor_viewport_3d(0).get_mouse_position();
	print("Click detected")
	var from = camera_3d.project_ray_origin(mousePos)
	var to = from + (camera_3d.project_ray_normal(mousePos) * 500.0)
	#var space = camera_3d.get_world_3d().direct_space_state
	var space = EditorInterface.get_editor_viewport_3d().find_world_3d().direct_space_state;
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.hit_back_faces = true
	rayQuery.collide_with_bodies = true
	rayQuery.hit_from_inside = true
	rayQuery.collision_mask = pow(2, 1-1)  #Set layer 1 (1-1) to true
	#Example for future reference: (Layer 1, 3, and 4)
	#pow(2, 1-1) + pow(2, 3-1) + pow(2, 4-1)
	var result = space.intersect_ray(rayQuery)
	if result.is_empty():
		print("Nothing found on raycast.")
		return
	var instance = prefab.instantiate()
	instance.name = str("Child" + var_to_str(get_child_count() + 1))
	add_child(instance, true)
	instance.position = result.position
	
	#instance.rotation = calculate_rotation_from_normal(result.normal)
	#These two lines added to replace the calculate rotation code
	#https://www.reddit.com/r/godot/comments/18blr03/rotate_3d_player_to_ground_normal/
	#var b_rotation = Quaternion(instance.transform.basis.y, result.normal)
	#instance.transform.basis = Basis(b_rotation * basis.get_rotation_quaternion())
	instance.transform.basis.y = result.normal;
	#end reddit line
	var r = RandomNumberGenerator.new()
	
	instance.rotate_y(deg_to_rad(r.randf_range(MyList[id].MinRotate, MyList[id].MaxRotate)))
	
	var r2 = RandomNumberGenerator.new()
	var s : float = r2.randf_range(MyList[id].MinScale, MyList[id].MaxScale)
	instance.scale.x *= s
	instance.scale.y *= s
	instance.scale.z *= s
	
	#print_tree()  
	instance.set_owner(owner) #Update the scene tree so the new object we placed shows up in the inspector
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		if Input.is_mouse_button_pressed (MOUSE_BUTTON_LEFT):
			if Input.is_key_pressed(KEY_CTRL):
				if not lastPressed:
					_on_click()
					lastPressed = true;
		if not Input.is_mouse_button_pressed (MOUSE_BUTTON_LEFT):
			lastPressed = false;

func _pick_prefab():
	var max : int = 0
	for i in MyList.size():
		max += MyList[i].Weight;
	
	var random : int = randi_range(0, max)
	
	var current : int = 0;
	for i in MyList.size():
		if current >= random:
			return i
			break
		current += MyList[i].Weight;
	
	return 0  #out of range, just give it the default
