extends GameState
class_name DefaultGameState

func _init(in_game_mode: GameModeData, in_game_seed: int, in_game_args: Dictionary) -> void:
	super(in_game_mode, in_game_seed, in_game_args)

func InitNewLocalPlayer() -> PlayerController:
	
	var new_local_player := super()
	
	var campaign_data := WorldGlobals._campaign_data
	var saved_inventory_data := JSON.parse_string(campaign_data.get_run_data(CampaignData.run_data_inventory_data, JSON.stringify({}))) as Dictionary
	
	var saved_container_scripts_paths := saved_inventory_data.keys()
	for sample_script_path: String in saved_container_scripts_paths:
		var sample_container := ModularGlobals.try_get_from(new_local_player, load(sample_script_path)) as ItemContainer
		sample_container.set_items_from_dictionary_string(saved_inventory_data[sample_script_path])
	return new_local_player

func end_play():
	
	var local_player := PlayerGlobals.PlayerArray[0]
	var campaign_data := WorldGlobals._campaign_data
	
	var inventory_data := {}
	for sample_container: ItemContainer in ItemContainer.get_all_containers_in_owner(local_player):
		var sample_script: Script = sample_container.get_script()
		inventory_data[sample_script.resource_path] = sample_container.get_items_dictionary_string()
	campaign_data.set_run_data(CampaignData.run_data_inventory_data, JSON.stringify(inventory_data))
	
	super()
