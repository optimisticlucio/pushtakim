extends Microgame

var car_passed_first_gate: bool = false;

@onready var gate_one: SafariGate = $FirstGate;
@onready var gate_two: SafariGate = $SecondGate;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gate_one.was_toggled.connect(on_gate_toggle);
	gate_two.was_toggled.connect(on_gate_toggle);

func on_gate_toggle() -> void:
	if players_victory_status_was_set:
		return;
	
	if gate_one.is_open and gate_two.is_open:
		escape_soldiers();
		return;
	
	if !car_passed_first_gate and gate_one.is_open:
		$AnimationPlayer.play("pass_first_gate");
		car_passed_first_gate = true;
	
	if car_passed_first_gate and gate_two.is_open:
		$AnimationPlayer.play("pass_second_gate");
		set_player_won_at_microgame();

## Lose condition; show visuals of soldiers running from base.
func escape_soldiers() -> void:
	set_player_lost_at_microgame();
	gate_one.is_toggleable = false;
	gate_two.is_toggleable = false;
	
	$AnimationPlayer.play("soldier_escape");
