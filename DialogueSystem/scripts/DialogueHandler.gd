class_name DialogueHandler extends Node3D


@export var ChoiceButtons : Array[NodePath];
@export var FlashImage : NodePath;

static var Instance : DialogueHandler;
var dialogueThread : DialogueGrid;
static var IsRunning = false;

static var CurrentX : int = 0;
static var CurrentY : int = 0;
static var variables : Dictionary;
static var Selected_Choice = -1;
var _scene_base : XRToolsSceneBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DialogueHandler.IsRunning = false;
	Instance = self;
	_scene_base = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	EndDialogue();

static func SetVariable(vname : String, vvalue : float):
	#if variables.find_key(vname) == null:  #Hasn't added variable yet
	#	print(str("Key ", vname, " does not exist yet."));
	#	vvalue = variables.get_or_add(vname, vvalue);
	#else:
	#	print(str("Key ", vname, " exists.  Setting to ", vvalue))
	#	variables[vname] = vvalue;
	variables[vname] = vvalue;

static func GetVariable(vname : String):
	
	if variables.has(vname) == false:  #Hasn't added variable yet
		#print(str("Get Var ", vname, "; Variable doesn't exist yet"));
		return 0.0;
	else:
		#print(str("Get Var ", vname, "; Variable exists; value is", variables[vname]));
		return variables[vname];


func StartDialogue(runThis : DialogueGrid):
	CurrentX = 0;
	CurrentY = 0;
	DialogueHandler.IsRunning = true;
	dialogueThread = runThis;
	ObtainDialogue();


#Using CurrentX and CurrentY, get the DialogueEntry node and start up the function
func ObtainDialogue():
	#Reset the dialogue box before the event
	visible = false;
	for c in ChoiceButtons:
		get_node(c).visible = false;
	if dialogueThread == null:
		return;
	
	var currentNode : DialogueEntry = dialogueThread.GetEntry(CurrentX, CurrentY);
	if currentNode == null:
		EndDialogue();
		return;
	else:
		DialogueHandler.IsRunning = true;
		
		var command = currentNode.cmd;
		var args = currentNode.GetArguments();
		if command == "str":
			StreamDialogueBox(args);
		if command == "choice":
			StreamChoiceBox(args);
		if command == "end":
			EndDialogue();
			return;
		if command == "var":
			StreamModifyVariables(args);
		if command == "tel":
			StreamTeleportNPC(args);
		if command == "wait":
			StreamWait(args);
		if command == "sce":
			SteamTeleport(args);
			return;
		if command == "msg":
			StreamSendMessage(args);
		if command == "ifthen":
			StreamIfThen(args);

func StreamIfThen(args : Array[String]):
	var variableName = args[0];
	var operatorStr = args[1];
	var valueStr = args[2];
	var nextNodeIfTrue = args[3];
	var nextNodeIfFalse = args[4];
	
	var valueLeft = DialogueArgsUtility.FilterDialogueVariables(variableName).to_float();
	var valueRight = DialogueArgsUtility.FilterDialogueVariables(valueStr).to_float();
	
	
	var isTrue = false;
	if operatorStr == "==":
		if is_equal_approx(valueLeft, valueRight):
			isTrue = true;
	if operatorStr == "!=":
		if is_equal_approx(valueLeft, valueRight) == false:
			isTrue = true;
	if operatorStr == ">":
		if valueLeft > valueRight:
			isTrue = true;
	if operatorStr == ">=":
		if valueLeft >= valueRight:
			isTrue = true;
	if operatorStr == "<":
		if valueLeft < valueRight:
			isTrue = true;
	if operatorStr == "<=":
		if valueLeft <= valueRight:
			isTrue = true;
	
	if isTrue:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeIfTrue);
	else:
		DialogueArgsUtility.SetNextNodeFromStr(nextNodeIfFalse);

	
func StreamSendMessage(args : Array[String]):
	var actorName = args[0];
	var signalName = args[1];
	var nextNodeStr = args[2];
	NPC.npcList[actorName].SendSignal(signalName);
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);

func SteamTeleport(args : Array[String], isExternal = false):
	await get_tree().create_timer(0.5).timeout;
	#LoadingUI.SceneToLoad = args[0];
	#BoilerPlate.StartingPosition = DialogueArgsUtility.ConvertStringToVector3(args[1]);
	#get_tree().change_scene_to_file("res://Scenes/Global/Loading.tscn");
	if not _scene_base:
		return

	var scene = args[0];
	var spawn_point_position : Vector3 = DialogueArgsUtility.ConvertStringToVector3(args[1]);
	# Teleport
	_scene_base.load_scene(scene, spawn_point_position)
	
	EndDialogue();
	
func StreamWait(args : Array[String]):
	var waitTime = args[0].to_float();
	var waitForMovement = true;
	if args[1] == "false":
		waitForMovement = false;
	var nextNodeStr = args[2];
	
	await get_tree().create_timer(waitTime).timeout;
	if waitForMovement == true:
		print("TODO: Wait for movement");
	
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);
	
	
func StreamTeleportNPC(args : Array[String]):
	var npcName = args[0];
	var positionStr = args[1].split(",");
	var nextNodeStr = args[2];
	var pos : Vector3 = Vector3(positionStr[0].to_float(), positionStr[1].to_float(), positionStr[2].to_float());
	NPC.npcList[npcName].TeleportActor(pos);
	DialogueArgsUtility.SetNextNodeFromStr(nextNodeStr);
	

func StreamModifyVariables(args : Array[String]):
	var varName = args[0];
	var finalValue = GetVariable(varName);
	
	var operator = args[1];
	var firstValue = DialogueArgsUtility.FilterDialogueVariables(args[2]).to_float();
	
	#Set var does this automatically
	if operator == "=":  #Add var
		finalValue = firstValue;
	if operator == "+=":  #Add var
		finalValue += firstValue;
	if operator == "-=":  #Subtract var
		finalValue -= firstValue;
	if operator == "*=":  #Multiply var
		finalValue *= firstValue;
	if operator == "/=":  #Divide var
		finalValue /= firstValue;
	if operator == "+":  #Add var
		finalValue += firstValue;
	if operator == "-":  #Subtract var
		finalValue -= firstValue;
	if operator == "*":  #Multiply var
		finalValue *= firstValue;
	if operator == "/":  #Divide var
		finalValue /= firstValue;
	
	SetVariable(varName, finalValue);
	DialogueArgsUtility.SetNextNodeFromStr(args[3]);

func StreamDialogueBox(args : Array[String]):
	
	var charName = args[0];
	visible = true;
	
	OverlayUI.CurrentSubtitle = "";
	var text : String = args[1];
	text = DialogueArgsUtility.FilterRichText(text);
	text = DialogueArgsUtility.FilterDialogueVariables(text);
	var charsPerSecond = DialogueArgsUtility.ConvertStringToFloat(args[2]);
	var soundFXDirectory = args[3];
	
	var asset_name : String = str("Dialogue/", soundFXDirectory, ".mp3");
	#get_node("AudioStreamPlayer3D").stream = load(asset_name);
	SoundFXPlayer.PlaySound(asset_name, get_tree(), PosVelCalc.HeadPos, 10.0, 2.0);
	#get_node("AudioStreamPlayer3D").play();
	
	var nextNode = args[4];
	
	var currentCharID = 1;
	while currentCharID < text.length():
		if currentCharID > text.length():
			currentCharID = text.length();
			
		currentCharID += 1;
		if currentCharID < text.length():  #Don't attempt this loop of closing tags unless we're at the end
			var tagFound = true;
			while tagFound == true:  #Putting this in a loop in case we have multiple tags next to each other
				if currentCharID >= text.length(): #We're at the end of the string, break the loop
					tagFound = false;
				if currentCharID < text.length():
					if text[currentCharID] == "[":	  #Keep the loop going, we're still processing tags
						currentCharID = text.find("]", currentCharID) + 1;
						if currentCharID > text.length(): #We're at the end of the string, break the loop
							currentCharID = text.length() - 1;
							tagFound = false;
					else:  #The next char is not a [, break the loop
						tagFound = false;
		if currentCharID > text.length():
			currentCharID = text.length() - 1;
			
		var subStr = text.substr(0, currentCharID);
		OverlayUI.CurrentSubtitle = subStr;
		await get_tree().create_timer(1.0 / charsPerSecond).timeout;
	
	#while Input.is_action_pressed("jump") == false:
	#	await get_tree().create_timer(1.0 / 60.0).timeout;
	
	await get_tree().create_timer(0.5).timeout;
	OverlayUI.CurrentSubtitle = "";
	
	DialogueArgsUtility.SetNextNodeFromStr(nextNode);



func StreamChoiceBox(args : Array[String]):
	visible = true;
	Selected_Choice = -1;
	var outputs = args[4].split(" ");
	
	for i in range(0, 4):
		if args[i] != "":  
			get_node(ChoiceButtons[i]).visible = true;
			get_node(ChoiceButtons[i]).text = args[i];
	get_node(ChoiceButtons[0]).grab_focus();
	
	while Selected_Choice == -1:
		await get_tree().create_timer(1.0 / 60.0).timeout;
	
	DialogueArgsUtility.SetNextNodeFromStr(outputs[Selected_Choice]);
	

func EndDialogue():
	dialogueThread = null;
	DialogueHandler.IsRunning = false;
	OverlayUI.CurrentSubtitle = "";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;


func _on_button_choice_1_pressed() -> void:
	Selected_Choice = 0;


func _on_button_choice_2_pressed() -> void:
	Selected_Choice = 1;


func _on_button_choice_3_pressed() -> void:
	Selected_Choice = 2;


func _on_button_choice_4_pressed() -> void:
	Selected_Choice = 3;
