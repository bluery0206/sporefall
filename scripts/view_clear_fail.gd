extends Control

const FAIL_MUSIC_PATH 			= "res://assets/music/fail.mp3"
@onready var clear_fail_bg_music	: AudioStream = preload(FAIL_MUSIC_PATH)

@onready var score: Label = $ClearFailedMenu/VBoxContainer/ScoreContainer/Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score.text = str(Globals.player_score)
	#print(Globals.player_score)

	BackgroundMusicPlayer.play_music(clear_fail_bg_music) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _restart() -> void:
	#print(Globals.prev_scene, "dasda")
	get_tree().change_scene_to_file(Globals.prev_scene)


func _go_to_levels() -> void:
	get_tree().change_scene_to_file("res://scenes/view_levels.tscn")


func _go_to_home() -> void:
	get_tree().change_scene_to_file("res://scenes/menus_main.tscn")
	


func _on_tree_exited() -> void:
	Globals.player_score= 0
