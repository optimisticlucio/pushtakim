extends Microgame



## The amount of clicks that the user needs to do to win the minigame. 
## SHOULD NOT BE MODIFIED DURING RUNTIME. The modifiable one is `amount_of_sips_left`.
@export 
var amount_of_sips_to_finish_drink: int = 1;

## The time after a sip, in seconds, where the user cannot sip once more. To help reduce mashing.
@export 
var spacing_between_sips_in_second: float = 0.2;

## The tropit sprite node. Should have a spritemap where the first frame is a full tropit, and the last is empty.
@export
var tropit_sprite_node: Sprite2D = null;

## The amount of seconds after which the sipping noise is stopped. If the player mashes sip, the sound doesn't loop.
@export 
var time_until_stop_sipping_noise: float = 0.3;

## The audio player for the sipping noise.
@export 
var sipping_noise_node: AudioStreamPlayer = null;

## The audio player for the satisfied noise.
@export 
var satisfied_noise_node: AudioStreamPlayer = null;

## The animation player that handles the animations of this minigame.
@export 
var animation_handler: AnimationPlayer = null;


## How long it's been since the user last sipped, in seconds.
var seconds_since_last_sip: float = spacing_between_sips_in_second;

## The amount of sips left for the user to sip to win the minigame.
var amount_of_sips_left: int = amount_of_sips_to_finish_drink;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	verify_assumptions();
	
	amount_of_sips_left = amount_of_sips_to_finish_drink;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	seconds_since_last_sip += delta;
	
	if sipping_noise_node.playing and seconds_since_last_sip > time_until_stop_sipping_noise:
		sipping_noise_node.stop();
		sipping_noise_node.seek(0);
		animation_handler.stop();

## Make sure that everything we assume here was configured properly, else toss errors.
func verify_assumptions() -> void:
	if amount_of_sips_to_finish_drink <= 0:
		push_error("[CONFIG ERROR] Tropit minigame has `amount_of_sips_to_finish_drink` set to a nonpositive number.");
	if tropit_sprite_node == null:
		push_error("[CONFIG ERROR] Tropit minigame has `tropit_sprite_node` unset.");
	if sipping_noise_node == null:
		push_error("[CONFIG ERROR] Tropit minigame has `sipping_noise_node` unset.");
	if satisfied_noise_node == null:
		push_error("[CONFIG ERROR] Tropit minigame has `satisfied_noise_node` unset.");
	if animation_handler == null:
		push_error("[CONFIG ERROR] Tropit minigame has `animation_handler` unset.");

## Returns a percentage between 0 to 1 of how much of the tropit is still undrank.
func get_percentage_of_tropit_left() -> float:
	return amount_of_sips_left as float/amount_of_sips_to_finish_drink;

## Takes a sip of the tropit.
func sip_drink() -> void:
	print("Sip drink called, amount of sips left is %s" % amount_of_sips_left);
	if seconds_since_last_sip < spacing_between_sips_in_second:
		return; # Hasn't been long enough to sip again.
	
	if amount_of_sips_left == 0:
		return; # The drink is complete ya greedy bastard.
	
	seconds_since_last_sip = 0;
	amount_of_sips_left -= 1;
	update_tropit_sprite();
	
	if amount_of_sips_left == 0:
		sipping_noise_node.stop();
		satisfied_noise_node.play();
		animation_handler.stop()
		set_player_won_at_microgame();
	else:
		if !sipping_noise_node.playing:
			sipping_noise_node.play(0);
			animation_handler.play("sip");

		# TODO: play sip animation.
		pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("game_click"):
			sip_drink();

## Update the tropit to look as drank-through as it is.
func update_tropit_sprite() -> void:
	var frame_amount = tropit_sprite_node.hframes * tropit_sprite_node.vframes;
	print("Percentage left: %s" % get_percentage_of_tropit_left())
	tropit_sprite_node.frame = round((1 - get_percentage_of_tropit_left()) * (frame_amount - 1));
	print("Frame set to: %s " % tropit_sprite_node.frame)
