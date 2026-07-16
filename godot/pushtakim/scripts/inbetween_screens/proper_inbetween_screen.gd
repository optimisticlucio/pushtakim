extends InbetweenScreen
	
func set_action_verb(passed_verb: String) -> void:
	$ActionLabel.text = "%s!" % passed_verb;

func set_remaining_lives(remaining_lives: int) -> void:
	$Lives.text = "פסילות: %s/3" % remaining_lives
