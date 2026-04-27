extends MicrogameOverlay

## The node that will turn visible once the user completes the minigame
@export
var player_won_node: Node2D = null;

## The node that will turn visible once the user fails the minigame
@export
var player_loss_node: Node2D = null;

## The node that shows the amount of time currently left in the microgame
@export
var clock_node: Label = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_won_node.visible = false;
	player_loss_node.visible = false;
	
	if player_won_node == null:
		push_error("[CONFIG ERROR] Test Overlay is missing `player_won_node`");
	if clock_node == null:
		push_error("[CONFIG ERROR] Test Overlay is missing `clock_node`");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta);
	
	clock_node.text = str(time_left_in_microgame).pad_decimals(2);


func on_player_win() -> void:
	player_won_node.visible = true;
	time_left_in_microgame = 0;

func on_player_loss() -> void:
	player_loss_node.visible = true;
	time_left_in_microgame = 0;

func reset() -> void:
	player_won_node.visible = false;
	player_loss_node.visible = false;
