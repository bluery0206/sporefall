extends Control

@onready var game_controls			: Control = $"../GameControls"
@onready var menus_game				: Control = $"."

@onready var menu_pause				: Control = $MenuPause




func _ready() -> void:
	menus_game.visible 				= false
	menu_pause.visible 				= false




func _continue() -> void:
	menu_pause.visible 		= false
	menus_game.visible 		= false
	Engine.time_scale 		= 1.0




func _restart() -> void:
	Globals.player_score 	= 0
	Engine.time_scale  		= 1.0

	get_tree().reload_current_scene()




func _levels() -> void:
	Engine.time_scale 	= 1.0
	Globals.prev_scene	= scene_file_path

	get_tree().change_scene_to_file("res://scenes/view_levels.tscn")




func _home() -> void:
	Engine.time_scale 		= 1.0

	get_tree().change_scene_to_file("res://scenes/menus_main.tscn")


func _on_game_manager_clear_success() -> void:
	
	get_tree().change_scene_to_file("res://scenes/view_clear_successful.tscn")
