class_name SaluteMicrogameSoldier extends Node2D

## The animation handler.
@export 
var animation_player: AnimationPlayer = null;

## Makes the soldier bounce
func bounce() -> void:
	animation_player.play("bounce");

## Makes the soldier enter a saulte and remain in it.
func salute() -> void:
	animation_player.play("salute");
