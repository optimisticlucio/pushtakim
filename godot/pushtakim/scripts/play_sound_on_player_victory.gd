extends AudioStreamPlayer

@export 
var parent_game_session: GameSession = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_game_session.player_won_microgame.connect(func(): 
		self.play()
		)
