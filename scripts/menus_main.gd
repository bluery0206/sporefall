extends Control

const bg_music_path = "res://assets/music/the_list_ones.mp3"

# getting current path
#Globals.prev_scene = scene_file_path


# per level, add a node that ssaves the current scene tree
# for the 'restart level' when dying or completion

# for completion, mst kill all the enemies and go throgh the door

@onready var menu_home			: Control = $MenuHome
@onready var menu_confirm_quit	: Control = $MenuConfirmQuit
@onready var start_new_game_confirm: Control = $StartNewGameConfirm
@onready var continue_button: Button = $MenuHome/VBoxContainer/MarginContainer/VBoxContainer/ContinueButton

@onready var bg_music			: AudioStream 	= preload(bg_music_path)

var is_new = true


func _ready() -> void:
	menu_home.visible 			= true
	menu_confirm_quit.visible 	= false
	start_new_game_confirm.visible = false
	
	var levels = ["level_one", "level_two", "level_three", "level_four", "level_five"]
	var data = Globals.load_data()
	if data.size() == 0 or data[levels[0]] == 0:
		for level in levels:
			data[level] = 0
		
		Globals.save_data(data)
		continue_button.visible= false
		is_new = true
	else:
		is_new = false
		continue_button.visible= true
		

	BackgroundMusicPlayer.play_music(bg_music) 

func _continue() -> void:
	var data = Globals.load_data()

	for idx in range(len(data)):
		if data[Globals.LEVELS[idx]] == 0:
			get_tree().change_scene_to_file("res://scenes/" + Globals.LEVELS[idx] + ".tscn")
			return

	get_tree().change_scene_to_file("res://scenes/" + Globals.LEVELS[-1] + ".tscn")



func _new_game() -> void:
	if is_new:
		_confirm_new_game()
	else:
		menu_confirm_quit.visible 	= false
		menu_home.visible 			= false
		start_new_game_confirm.visible = true

func _levels() -> void:
	Globals.prev_scene = scene_file_path
	get_tree().change_scene_to_file("res://scenes/view_levels.tscn")
	

func _quit() -> void:
	menu_confirm_quit.visible 	= true
	menu_home.visible 			= false
	start_new_game_confirm.visible = false
	
func _confirm_quit() -> void:
	get_tree().quit()

func _cancel_quit() -> void:
	menu_confirm_quit.visible 	= false
	menu_home.visible 			= true
	start_new_game_confirm.visible = false


func _confirm_new_game() -> void:
	var data = Globals.load_data()
	
	for level in data:
		data[level] = 0
		
	Globals.save_data(data)
	
	get_tree().change_scene_to_file("res://scenes/level_one.tscn")

func _cancel_new_game() -> void:
	menu_confirm_quit.visible 	= false
	menu_home.visible 			= true
	start_new_game_confirm.visible = false
