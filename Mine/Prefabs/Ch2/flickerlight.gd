extends OmniLight3D

@export var flickerCount = 5;
@export var delayBeforeFlicker = 2.0;
@export var delayPerFlicker = 0.1;

var isOn = false;
var flickerStep = -1;
var flickerTimer = 0.0;
var startingEnergy = 0.2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flickerStep = -1;
	flickerTimer = 0.0;
	isOn = false;
	startingEnergy = light_energy;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOn:
		light_energy = startingEnergy;
	else:
		light_energy = 0.0;
		
	
	flickerTimer += delta;
	if flickerStep == -1:  
		if flickerTimer >= delayBeforeFlicker: #Just turned on and started flickering
			flickerTimer = 0.0;
			isOn = true;
			flickerStep = 0;
	
	if flickerStep >= 0 and flickerStep <= (flickerCount * 2):
		if flickerTimer >= delayPerFlicker: #Flicker step
			isOn = !isOn;
			flickerTimer = 0.0;
			flickerStep += 1;
			return;
			
	if flickerStep > (flickerCount * 2): #End of flickering
		flickerStep = -1;
		flickerTimer = 0.0;
		isOn = false;
