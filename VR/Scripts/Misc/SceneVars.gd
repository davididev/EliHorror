class_name SceneVars extends Node3D

@export var MusicPath : String = "";
@export var DialogueOnStart : DialogueGrid;
@export var ResetHealth = true;
@export var ChapterHeader = "";
static var CurrentHealth = 100;
static var KeyCollected = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KeyCollected = false;
	if ResetHealth:
		CurrentHealth = 100;
	OverlayUI.CurrentChapterHeader = "";
	if MusicPath != "":
		PlayMusic.PlaySong(MusicPath);
		
	if DialogueOnStart != null:
		await get_tree().create_timer(0.1).timeout;
		DialogueHandler.Instance.StartDialogue(DialogueOnStart);

	if ChapterHeader != "":
		RunChapterHeader();

func RunChapterHeader():
	var max = ChapterHeader.length();
	for i in range(0, max):
		OverlayUI.CurrentChapterHeader = ChapterHeader.substr(0, i);
		SoundFXPlayer.PlaySound("typewriter.mp3", get_tree(), global_position, 20.0, 10.0);
		await get_tree().create_timer(0.15).timeout;
	
	OverlayUI.CurrentChapterHeader = ChapterHeader;
	await get_tree().create_timer(2.0).timeout;
	OverlayUI.CurrentChapterHeader = "";
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
