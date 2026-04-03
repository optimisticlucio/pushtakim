class_name GameSession extends Node2D
## The instance that actually controls a running game. Choosing which microgame to play next, whether or not the player won, etc.

## The microgames set by the developer to be playable under this game mode. Should not be modified during runtime.
@export
var microgames_for_this_session: Array[PackedScene] = [];

## The amount of lives a player starts with. Should not be modified during runtime.
@export
var starting_lives: int = 3;


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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_variables();
	
	start_new_microgame();

func _process(delta: float) -> void:
	if current_loaded_microgame:
		if current_loaded_microgame.length_in_seconds < seconds_on_current_microgame:
			handle_finished_microgame();
			start_new_microgame();
		else:
			seconds_on_current_microgame += delta;


## Should be run during `_ready()`; initializes any runtime variables that can't be known ahead of time.
func setup_variables() -> void:
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

## Returns true if the given PackedScene's root node is a Microgame node.
func is_microgame_scene(packed_scene: PackedScene) -> bool:
	var state = packed_scene.get_state();
	var root_class = state.get_node_type(0);
	return ClassDB.is_parent_class(root_class, "Microgame") or root_class == "Microgame";


## When called, instantiates a new microgame for the player.
func start_new_microgame() -> void:
	if available_microgames.is_empty():
		push_error("[RUNTIME ERROR] Ran `start_new_microgame` when `available_microgames` was already exhausted. Make more microgames or shorten the game!");
	
	# available_microgames is enforced to only be microgames during setup.
	var next_microgame = available_microgames.pop_front();
	
	current_loaded_microgame = next_microgame.instantiate();
	# TODO: Place it appropriately in the scene tree.
	
	seconds_on_current_microgame = 0;

## Called when a microgame finishes. Handles the cleanup of the current microgame and loading the next one, if appropriate.
func handle_finished_microgame() -> void:
	# TODO: Handle points and such.
	
	# TODO: Unload current microgame
	
	current_loaded_microgame = null;
