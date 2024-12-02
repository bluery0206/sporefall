extends Control

@onready var score_label: Label = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/ScoreContainer/ScoreLabel
@onready var score: Label = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/ScoreContainer/Score
@onready var new_best_score_label: Label = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/ScoreContainer/NewBestScoreLabel

@onready var old_best_score_container: HBoxContainer = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/OldBestScoreContainer
@onready var old_score_label: Label = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/OldBestScoreContainer/OldScoreLabel
@onready var old_score: Label = $ClearSuccessfulMenu/VBoxContainer/VBoxContainer/OldBestScoreContainer/OldScore


func _ready() -> void:
	var prev_scene_name = load(Globals.prev_scene).instantiate().name
	var prev_level = "level_" + prev_scene_name.split("Level")[1].to_lower()
	var data = Globals.load_data()
		
	score.text = str(Globals.player_score)
	
	if Globals.player_score > data[prev_level]:
		if data[prev_level] <= 0:
			new_best_score_label.visible = true
			score_label.visible = false
		else:
			new_best_score_label.visible = false
			old_best_score_container.visible = true
			old_score.visible = true
			old_score.text = str(data[prev_level])
			score_label.visible = true
			
		data[prev_level] = Globals.player_score
			
		Globals.save_data(data)

func _on_tree_exited() -> void:
	old_best_score_container.visible = false
	Globals.player_score= 0


func _restart() -> void:
	get_tree().change_scene_to_file(Globals.prev_scene)


func _go_to_levels() -> void:
	get_tree().change_scene_to_file("res://scenes/view_levels.tscn")


func _go_to_home() -> void:
	get_tree().change_scene_to_file("res://scenes/menus_main.tscn")


func _go_to_next_level() -> void:
	var data = Globals.load_data()
	
	for idx in range(len(data)):
		if data[Globals.LEVELS[idx]] == 0:
			get_tree().change_scene_to_file("res://scenes/" + Globals.LEVELS[idx] + ".tscn")
			return
	
	get_tree().change_scene_to_file("res://scenes/view_levels.tscn")
		
