class_name OverlayUI extends Control

static var CurrentSubtitle : String;
static var CurrentChapterHeader : String;
#@export var subtitleRef : NodePath;

var refresh_time_timer = 0.0;
var dyingRoutine = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dyingRoutine = false;
	refresh_time_timer = 0.0;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dyingRoutine == false:
		get_node("Subtitle").text = CurrentSubtitle;
		get_node("Chapter Header").text = CurrentChapterHeader;
		get_node("HealthBar").value = SceneVars.CurrentHealth;
		if SceneVars.CurrentHealth <= 0:
			get_node("HealthBar").visible = false;
			var args : Array[String];
			args.append(DialogueHandler.LastScene);
			args.append("0,0,0");
			DialogueHandler.Instance.SteamTeleport(args, true);
			DialogueHandler.Instance.SteamTeleport(args, true)
			dyingRoutine = true;
	RefreshTime(delta);
		
	
func RefreshTime(delta: float):
	refresh_time_timer -= delta;
	if refresh_time_timer <= 0.0:
		var today = Time.get_datetime_dict_from_system();
		var hour = today.hour;
		if hour >= 12:  #More than 12 PM
			hour -= 12;
		var is_pm = today.hour >= 12;
		var minuteStr = str(today.minute);
		if today.minute < 10:
			minuteStr = "0" + minuteStr;
		
		if hour == 0:  #12 PM or 12 AM
			if is_pm:
				get_node("Time Label").text = str(12, ":", minuteStr, "PM");
			else:
				get_node("Time Label").text = str(12, ":", minuteStr, "AM");
		else:
			if is_pm:
				get_node("Time Label").text = str(hour, ":", minuteStr, "PM");
			else:
				get_node("Time Label").text = str(hour, ":", minuteStr, "AM");
