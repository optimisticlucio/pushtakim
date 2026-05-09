@abstract class_name InbetweenScreen extends Node2D

## This function places whatever string is passed to it in the "Action Verb" location of the inbetween screen.
## Should be run on _ready().
@abstract func set_action_verb(passed_verb: String) -> void;
