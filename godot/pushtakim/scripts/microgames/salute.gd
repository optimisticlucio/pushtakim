extends Microgame

## The node which will be playing the music.
@export 
var audio_stream_node: AudioStreamPlayer = null;

## The amount of time before the end of the minigame that the salute will happen, for timing purposes.
@export
var salute_distance_from_end: float = 1;

## The track with the "HAKSHEV" that the user will salute to.
@export
var track_to_salute_to: AudioStream = null;

## The time, in seconds, in `tack_to_salute_to`, where the salute happens.
@export
var time_to_salute_to: float = 8;

## The frequency, in seconds, that the soldiers will bounce before the salute.
@export
var bounce_frequency: float = 1;

## How many seconds off from the correct timing the user can be and still win the microgame.
@export
var salute_lenience: float = 0.5;

## The NPCs which indicate to the player what to do.
@export 
var npc_soldiers: Array[SaluteMicrogameSoldier] = [];

## The player's soldier which only moves when they salute.
@export
var player_soldier: SaluteMicrogameSoldier = null;


## The amount of time left in this microgame until the salute happens.
var time_until_salute: float = 0;

## The amount of time left until there should be a soldier bounce.
var time_until_bounce: float = 0;

## Whether or not the player saluted this microgame.
var has_player_saluted: bool = false;

## Whether or not the salute call already occured.
var has_salute_happened: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_assumptions();
	set_audio_timing();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_until_salute -= delta;
	time_until_bounce -= delta;
	
	if time_until_bounce <= 0:
		if (time_until_salute > 0):
			soldier_bounce();
		else:
			soldier_salute();
		time_until_bounce += bounce_frequency;

## Sets the audio to the right amount of time before the HAKSHEV, ran at initialization.
func set_audio_timing() -> void:
	time_until_salute = length_in_seconds - salute_distance_from_end;
	var time_to_start_music_on: float = time_to_salute_to - time_until_salute;
	
	time_until_bounce = fmod(time_until_salute, bounce_frequency);
	
	audio_stream_node.autoplay = false;
	audio_stream_node.stream = track_to_salute_to;
	audio_stream_node.play(time_to_start_music_on);

## Makes sure the configuration is valid, throws error otherwise.
func check_assumptions() -> void:
	if salute_distance_from_end <= 0 or time_to_salute_to <= 0 or bounce_frequency <= 0:
		push_error("[CONFIG ERROR] There's a nonpositive value in the salute microgame's configuration.");
	if track_to_salute_to == null:
		push_error("[CONFIG ERROR] The salute microgame has no track to salute to.");
	if audio_stream_node == null:
		push_error("[CONFIG ERROR] There's no audio stream node hooked up in the salute microgame.");
	if player_soldier == null:
		push_error("[CONFIG ERROR] There's no player soldier hooked up in the salute microgame.");

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("game_click"):
			player_salute();

## Ran when the player tries to salute. Does the salute animation and checks whether the player won the microgame.
func player_salute() -> void:
	# You can only salute once! 
	if has_player_saluted:
		return;
	has_player_saluted = true;
	
	player_soldier.salute();
	
	if abs(time_until_salute) <= salute_lenience:
		set_player_won_at_microgame();
	else:
		set_player_lost_at_microgame();

## Ran every time the soldiers need to bounce.
func soldier_bounce() -> void:
	for soldier in npc_soldiers:
		soldier.bounce();

## Ran when we need the soliders to properly salute.
func soldier_salute() -> void:
	# They can only salute once.
	if has_salute_happened:
		return;
	has_salute_happened = true;
	
	for soldier in npc_soldiers:
		soldier.salute();
