extends Control

@onready var hs_level_4: Label = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer4/Level-4/MarginContainer/Control/VBoxContainer/Contol/HighestLevelLabel"
@onready var hs_level_3: Label = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer3/Level-3/MarginContainer/Control/VBoxContainer/Contol/HighestLevelLabel"
@onready var hs_level_2: Label = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer2/Level-2/MarginContainer/Control/VBoxContainer/Contol/HighestLevelLabel"
@onready var hs_level_1: Label = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer/Level-1/MarginContainer/Control/VBoxContainer/Contol/HighestLevelLabel"
@onready var hs_level_5: Label = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer5/Level-5/MarginContainer/Control/VBoxContainer/Contol/HighestLevelLabel"

@onready var unlock_panel_level_two: Panel = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer2/Level-2/Panel"
@onready var unlock_panel_level_three: Panel = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer3/Level-3/Panel"
@onready var unlock_panel_level_four: Panel = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer4/Level-4/Panel"
@onready var unlock_panel_level_five: Panel = $"MenuLevels/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer/MarginContainer5/Level-5/Panel"

func _back() -> void:
	#print("Globals.prev_scene: " + Globals.prev_scene)
	
	var target_scene
	
	if (
		"Level" not in Globals.prev_scene and 
		"level" not in Globals.prev_scene and
		 Globals.prev_scene 
	):
		target_scene = Globals.prev_scene
	else:
		target_scene = "res://scenes/menus_main.tscn"
		
	get_tree().change_scene_to_file(target_scene)


func _ready() -> void:
	var data = Globals.load_data()
	
	#print(data)
	
	if data["level_one"] > 0:
		hs_level_1.visible = true
		hs_level_1.text += " " + str(data["level_one"])
	else:
		hs_level_1.visible = false
		
	if data["level_one"] <= 0:
		unlock_panel_level_two.visible = true
		data["level_two"] = 0
	else:
		if data["level_two"] > 0:
			hs_level_2.visible = true
			hs_level_2.text += " " + str(data["level_two"])
		else:
			hs_level_2.visible = false
		unlock_panel_level_two.visible = false
		
		
	if data["level_two"] <= 0:
		unlock_panel_level_three.visible = true
		data["level_three"] = 0
	else:
		if data["level_three"] > 0:
			hs_level_3.visible = true
			hs_level_3.text += " " + str(data["level_three"])
		else:
			hs_level_3.visible = false
		unlock_panel_level_three.visible = false
		
		
	if data["level_three"] <= 0:
		unlock_panel_level_four.visible = true
		data["level_four"] = 0
	else:
		if data["level_four"] > 0:
			hs_level_4.visible = true
			hs_level_4.text += " " + str(data["level_four"])
		else:
			hs_level_4.visible = false
		unlock_panel_level_four.visible = false
		
	if data["level_four"] <= 0:
		unlock_panel_level_five.visible = true
		data["level_five"] = 0
	else:
		if data["level_five"] > 0:
			hs_level_5.visible = true
			hs_level_5.text += " " + str(data["level_five"])
		else:
			hs_level_5.visible = false
		unlock_panel_level_five.visible = false

	Globals.save_data(data)
	
	
func _enter_level_one() -> void:
	get_tree().change_scene_to_file("res://scenes/level_one.tscn")


func _enter_level_two() -> void:
	get_tree().change_scene_to_file("res://scenes/level_two.tscn")


func _enter_level_three() -> void:
	get_tree().change_scene_to_file("res://scenes/level_three.tscn")


func _etner_level_four() -> void:
	get_tree().change_scene_to_file("res://scenes/level_four.tscn")


func _enter_level_five() -> void:
	get_tree().change_scene_to_file("res://scenes/level_five.tscn")
