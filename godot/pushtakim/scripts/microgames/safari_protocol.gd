extends Microgame


var first_gate_open: bool = false;
var second_gate_open: bool = false;

var car_passed_first_gate: bool = false;

@onready var gate_one_button: Button = $GateOneTrigger;
@onready var gate_two_button: Button = $GateTwoTrigger;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gate_one_button.button_down.connect(toggle_first_gate);
	gate_two_button.button_down.connect(toggle_second_gate);

## Opens/closes the first gate
func toggle_first_gate() -> void:
	first_gate_open = !first_gate_open;
	
	# Update visuals
	pass
	
	# Check conditions
	if second_gate_open:
		escape_soldiers();
		return;
	
	if !car_passed_first_gate:
		car_passed_first_gate = true;
		# TODO: Visualize the car passing
	

## Opens/closes the second gate
func toggle_second_gate() -> void:
	second_gate_open = !second_gate_open;
	
	# Update visuals
	pass
	
	# Check conditions
	if first_gate_open:
		escape_soldiers();
		return;

## Lose condition; show visuals of soldiers running from base.
func escape_soldiers() -> void:
	set_player_lost_at_microgame();
	
	# TODO: Visuals
