extends InbetweenScreen
	
func set_action_verb(passed_verb: String) -> void:
	$ActionVerb.text = "%s!" % passed_verb;

func set_remaining_lives(remaining_lives: int) -> void:
	$Label.text = "יש לך עוד %s חיים" % remaining_lives
