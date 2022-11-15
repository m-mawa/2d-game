extends Button

var player_character_path = "res://src/Actors/Player1.tscn"
export(String, FILE) var next_scene_path: = "res://src/Levels/Level01.tscn"

func _on_button_up() -> void:
	PlayerData.reset()
	get_tree().change_scene(next_scene_path)

func _ready() -> void:
	var player_character = load(player_character_path).instance()
	add_child_below_node(get_tree().get_root().get_node("Level01"),player_character)
