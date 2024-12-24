extends Control

@export var creditsRef : CreditsRoot;
var currentCategory = 0;
var currentEntry = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentCategory = 0;
	currentEntry = 0;
	DrawCurrentEntry();

func DrawCurrentEntry():
	if currentCategory < 0:
		currentCategory = creditsRef.categories.size() - 1;
	if currentCategory >= creditsRef.categories.size():	
		currentCategory = 0;
	if currentEntry < 0:
		currentEntry = creditsRef.categories[currentCategory].entries.size() - 1;
	if currentEntry >= creditsRef.categories[currentCategory].entries.size():
		currentEntry = 0;
	
	var max = creditsRef.categories[currentCategory].entries.size();
	var min = currentEntry + 1;
	var s = str("[center][b]", creditsRef.categories[currentCategory].CategoryName, min, "/", max, "[/b]\n");
	s = s + str(creditsRef.categories[currentCategory].entries[currentEntry].Item, "by [color=yellow]", creditsRef.categories[currentCategory].entries[currentEntry].Source, "[/color][/center]")
	get_node("RichTextLabel").text = s;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_prev_category_pressed() -> void:
	currentCategory -= 1;
	currentEntry = 0;
	DrawCurrentEntry();


func _on_btn_next_category_pressed() -> void:
	currentCategory += 1;
	currentEntry = 0;
	DrawCurrentEntry();


func _on_btn_prev_entry_pressed() -> void:
	currentEntry -= 1;
	DrawCurrentEntry();


func _on_btn_next_entry_pressed() -> void:
	currentEntry += 1;
	DrawCurrentEntry();
