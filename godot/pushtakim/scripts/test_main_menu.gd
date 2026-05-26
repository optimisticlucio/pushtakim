extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Explanation.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/default_game_session.tscn")


func explanation_button_pressed() -> void:
	$Explanation.visible = true;


func exit_explanation_pressed() -> void:
	$Explanation.visible = false;
