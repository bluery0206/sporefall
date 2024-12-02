extends Node

const SAVE_PATH = "user://globals.json"

const LEVELS = ["level_one", "level_two", "level_three", "level_four", "level_five"]

var player_score: int :
	set(_value):
		player_score = round(_value)
	get:
		return player_score if player_score else 0
var best_score: int : 
	get:
		return best_score if best_score else 0
var player_pos: Vector2

var prev_scene_name: String
var prev_scene: String


func _ready() -> void:
	pass

func save_data(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))  # Pretty-print
		file.close()

# Load data from JSON
func load_data() -> Dictionary:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var json = JSON.new()
			if json.parse(content) == OK:
				return json.get_data()
	return {}  # Return empty if file doesn't exist or parsing fails
