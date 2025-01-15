extends Node3D

var player_touching_body : Node3D;
var player_touch_timer = 0.0;
const TOUCH_DELAY = 1.0;
const DAMAGE_AMOUNT = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_touching_body = null;
	player_touch_timer = 0.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_touch_timer += delta;
	if player_touch_timer > TOUCH_DELAY:
		player_touch_timer -= TOUCH_DELAY;
		if player_touching_body != null:  #Only process damage if player is touching
			player_touching_body.emit_signal("OnDamage", DAMAGE_AMOUNT, global_position);


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		player_touching_body = body;


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		player_touching_body = null;
