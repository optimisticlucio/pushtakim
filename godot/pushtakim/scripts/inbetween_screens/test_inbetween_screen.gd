extends InbetweenScreen
	
func set_action_verb(passed_verb: String) -> void:
	$ActionVerb.text = "%s!" % passed_verb;
