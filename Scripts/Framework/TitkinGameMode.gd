extends GameModeData
class_name TitkinGameModeData

func init_new_game_state(in_game_seed: int, in_args: Dictionary) -> GameState:
	var out_game_state = TitkinGameState.new(self, in_game_seed, in_args)
	return out_game_state
