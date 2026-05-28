extends Node2D

## The amount of seconds this screen will wait before switching to the main menu
@export var seconds_before_going_to_main_menu: float = 15;

func _process(delta: float) -> void:
	seconds_before_going_to_main_menu -= delta;
	
	if seconds_before_going_to_main_menu < 0:
		get_tree().change_scene_to_file("res://scenes/test_main_menu.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/default_game_session.tscn")
