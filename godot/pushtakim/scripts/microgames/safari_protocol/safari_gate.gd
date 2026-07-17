class_name SafariGate extends Node2D


var is_open: bool = false;

var is_toggleable: bool = true;

signal was_toggled;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(toggle_gate)
	$GateCenter.offset = Vector2(0,0)

func toggle_gate() -> void:
	if !is_toggleable:
		return;
	
	is_open = !is_open;
	was_toggled.emit();
	$GateSqueak.play();
	
	if is_open:
		$GateCenter.offset = Vector2(240,370);
	else:
		$GateCenter.offset = Vector2(0,0);
