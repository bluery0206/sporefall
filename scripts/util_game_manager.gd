extends Control

signal clear_success

const CLEAR_SUCCESS_MUSIC_PATH  = "res://assets/music/success.mp3"
const FAIL_MUSIC_PATH 			= "res://assets/music/fail.mp3"
const GAME_MUSIC_PATH 			= "res://assets/music/game.mp3"
const SEA_OF_DOOM 				= "res://assets/music/sea_of_doom.mp3"

@onready var game_bg_music			: AudioStream = preload(GAME_MUSIC_PATH)
@onready var clear_success_bg_music	: AudioStream = preload(CLEAR_SUCCESS_MUSIC_PATH)
@onready var clear_fail_bg_music	: AudioStream = preload(FAIL_MUSIC_PATH)
@onready var sea_of_doom			: AudioStream = preload(SEA_OF_DOOM)

@onready var enemies_count_label		: Label = $"../CanvasLayer/GameControls/ScoreBoard/MarginContainer/VBoxContainer/EnemiesCountcontainer/EnemiesCount"
@onready var enemies_count_total_label	: Label = $"../CanvasLayer/GameControls/ScoreBoard/MarginContainer/VBoxContainer/EnemiesCountcontainer/EnemiesCountTotal"
@onready var score_label				: Label = $"../CanvasLayer/GameControls/ScoreBoard/MarginContainer/VBoxContainer/ScoreContainer/Score"

@onready var enemies: Node2D = $"../Enemies"


var enemies_count_total	: int
var enemies_count		: int
var is_cleared			: bool

func _ready():
	var level_name = "level_" + get_parent().name.split("Level")[-1].to_lower()
	var music = sea_of_doom if level_name == "level_five" else game_bg_music
	BackgroundMusicPlayer.play_music(music) 
	Globals.player_score = 0
	
	enemies_count_total	= enemies.get_child_count()
	
	var data = Globals.load_data()
	
	if data.size() == 0 or level_name not in data:
		data[level_name] = 0
		Globals.save_data(data)

func _process(_delta: float) -> void:
	enemies_count = enemies.get_child_count()
	
	update_scoreboard()
	#print(enemies_count)
	if enemies_count == 0 and is_cleared:
		Globals.prev_scene = get_parent().scene_file_path
		
		BackgroundMusicPlayer.play_music(clear_success_bg_music) 
		clear_success.emit()
	
func update_scoreboard():
	score_label.text				= str( Globals.player_score )
	enemies_count_label.text		= str( enemies_count )
	enemies_count_total_label.text	= str( enemies_count_total )


func _on_end_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	is_cleared = true

func _on_end_body_entered(_body: Node2D) -> void:
	is_cleared = true
