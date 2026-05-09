class_name GameSession extends Node2D
## The instance that actually controls a running game. Choosing which microgame to play next, whether or not the player won, etc.

## The microgames set by the developer to be playable under this game mode. Should not be modified during runtime.
@export
var microgames_for_this_session: Array[PackedScene] = [];

## The inbetween screens that may appear between minigames. Should not be modified during runtime.
@export
var inbetween_screens_for_this_session: Array[PackedScene] = [];

## The amount of lives a player starts with. Should not be modified during runtime.
@export
var starting_lives: int = 3;

## The node under which the microgames will be instantiated. 
## SHOULD NOT HAVE ANY CHILDREN! If this variable is null, a runtime error is thrown. 
@export
var microgame_holding_node: Node2D = null;

## The overlay which will only be visible during microgames.
@export
var overlay_node: MicrogameOverlay = null;

## The amount of time between each minigame, in seconds, spent in the menu.
@export
var break_time_between_minigames: float = 1;

## The amount of time to remain on a minigame screen after its completed, for timeout stuff. In seconds.
@export
var post_minigame_wait_period_in_seconds: float = 1;

## The microgames which haven't been played in this particular game session. 
## Changes during runtime. If you want the originally set ones, reference `microgames_for_this_session`.
var available_microgames: Array[PackedScene] = []; 

## The amount of lives a player has remaining for this given game session.
## Changes during runtime. If you want the originally set ones, reference `starting_lives`.
var remaining_lives: int = 0;

## The amount of time spent on the current microgame. Will probably be a few miliseconds off.
var seconds_on_current_microgame: float = 0;

## MAY BE NULL. Points towards the loaded microgame scene. If it's null, we don't have a microgame loaded.
var current_loaded_microgame: Microgame = null;

## SHOULD NOT BE NULL. Points towards the next microgame we'll be giving the player.
var next_microgame: Microgame = null;

## Signal that triggers the moment a player completes the microgame win condition. Triggered by the microgame, this just passes it forward.
signal player_won_microgame;

## Signal that triggers the moment a player irreversibly fails a microgame win condition. Triggered by the microgame, this just passes it forward.
signal player_lost_microgame;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_variables();
	
	player_won_microgame.connect(end_microgame_early);
	player_lost_microgame.connect(end_microgame_early);
	
	await show_inbetween_screen();
	start_new_microgame();

func _process(delta: float) -> void:
	if current_loaded_microgame:
		seconds_on_current_microgame += delta
		
		if current_loaded_microgame.length_in_seconds < seconds_on_current_microgame:
			current_loaded_microgame.set_default_victory_state();
			if current_loaded_microgame.length_in_seconds + post_minigame_wait_period_in_seconds < seconds_on_current_microgame:
				replace_current_microgame();

## When ran, enters the microgame into the ending phase.
func end_microgame_early() -> void:
	seconds_on_current_microgame = current_loaded_microgame.length_in_seconds;

## Function that's run every time a microgame ends. Cleans up the current microgame, shows info to player, and then loads up a new one.
func replace_current_microgame():
	handle_finished_microgame();
	
	await show_inbetween_screen();
	
	start_new_microgame();

## Should be run during `_ready()`; initializes any runtime variables that can't be known ahead of time.
func setup_variables() -> void:
	# Validate our assumptions exist
	if microgame_holding_node == null: 
		push_error("[CONFIG ERROR] In the loaded game session setup, `microgame_holding_node` is unset.");
	if microgames_for_this_session.is_empty():
		push_error("[CONFIG ERROR] In the loaded game session setup, `microgames_for_this_session` is empty.");
	if overlay_node == null:
		push_error("[CONFIG ERROR] In the loaded game session setup, `overlay_node` is empty.");
	if seconds_on_current_microgame < 0:
		push_error("[CONFIG ERROR] In the loaded game session setup, `seconds_on_current_microgame` is set to a negative value.")
	
	# Assumptions valid, let's rock
	remaining_lives = starting_lives;
	
	# Load all the packed scenes. If any of them are not a microgame, throw an error.
	var loaded_microgames = [];
	for packed_scene in microgames_for_this_session:
		if not is_microgame_scene(packed_scene):
			push_error("[CONFIG ERROR] In the loaded game session setup, a scene in `microgames_for_this_session` is not a microgame! Specifically, the scene %s." % packed_scene.resource_name);
		loaded_microgames.push_back(packed_scene);
	
	# The microgames will be a double deck shuffle so there's a chance of repeats but likely will be unique.
	available_microgames.append_array(loaded_microgames);
	available_microgames.append_array(loaded_microgames);
	available_microgames.shuffle();
	
	# The overlay should be hidden outside of microgames.
	overlay_node.visible = false;
	player_won_microgame.connect(overlay_node.on_player_win);
	player_lost_microgame.connect(overlay_node.on_player_loss);
	
	# And load our first microgame.
	next_microgame = available_microgames.pop_front().instantiate();

## Returns true if the given PackedScene's root node is a Microgame node.
func is_microgame_scene(packed_scene: PackedScene) -> bool:
	var state = packed_scene.get_state()
	for i in state.get_node_property_count(0):
		if state.get_node_property_name(0, i) == "script":
			var script = state.get_node_property_value(0, i) as GDScript
			while script:
				if script.get_global_name() == "Microgame":
					return true
				script = script.get_base_script()
	return false

## Sets the next microgame. Should be run before `start_new_microgame` or `show_inbetween_screen` so they both have relevant data to show.

## When called, instantiates a new microgame for the player.
func start_new_microgame() -> void:
	if available_microgames.is_empty():
		push_error("[RUNTIME ERROR] Ran `start_new_microgame` when `available_microgames` was already exhausted. Make more microgames or shorten the game!");
	
	current_loaded_microgame = next_microgame;
	# Next_microgame should never be pointing at the same game as the current one.
	next_microgame = available_microgames.pop_front().instantiate();
	
	# Connect the relevant signals.
	current_loaded_microgame.player_wins_at_microgame.connect(player_won_microgame.emit);
	current_loaded_microgame.player_loses_at_microgame.connect(player_lost_microgame.emit);
	
	microgame_holding_node.add_child(current_loaded_microgame);
	
	# Set up overlay
	overlay_node.reset();
	overlay_node.set_variables(current_loaded_microgame.length_in_seconds);
	overlay_node.visible = true;
	
	seconds_on_current_microgame = 0;

## Called when a microgame finishes. Handles the cleanup of the current microgame and loading the next one, if appropriate.
func handle_finished_microgame() -> void:
	var player_won_at_microgame = current_loaded_microgame.player_has_won_at_microgame();
	
	current_loaded_microgame.free();
	current_loaded_microgame = null;
	
	overlay_node.visible = false;
	
	if player_won_at_microgame:
		# TODO: Show player a cool "yippee! You did it" screen
		pass 
	else:
		# TODO: Show player a "boo! you failed" screen
		remaining_lives -= 1;
		
		# TODO: If player's lives are at zero, show loss screen.

## When called, shows a random inbetween screen to the player for `break_time_between_minigames` seconds.
func show_inbetween_screen() -> void:
	var inbetween_screen_scene: InbetweenScreen = inbetween_screens_for_this_session.pick_random().instantiate();
	
	inbetween_screen_scene.set_action_verb(next_microgame.hebrew_action_verb);
	
	self.add_child(inbetween_screen_scene);
	
	await get_tree().create_timer(break_time_between_minigames).timeout;
	
	inbetween_screen_scene.queue_free();
