extends Control

@onready var menus_game: Control = $"../MenusGame"
@onready var menu_pause: Control = $"../MenusGame/MenuPause"

@onready var right_button	: TouchScreenButton = $MovementControls/RightButton
@onready var left_button	: TouchScreenButton = $MovementControls/LeftButton
@onready var shoot			: TouchScreenButton = $InteractionControls/Shoot
@onready var swing			: TouchScreenButton = $InteractionControls/Swing
@onready var jump			: TouchScreenButton = $InteractionControls/Jump
@onready var pause			: TouchScreenButton = $GameMenu/Pause




func _on_right_button_pressed() -> void:
	right_button.modulate.a = 0.75

func _on_right_button_released() -> void:
	right_button.modulate.a = 1




func _on_left_button_pressed() -> void:
	left_button.modulate.a = 0.75

func _on_left_button_released() -> void:
	left_button.modulate.a = 1




func _on_jump_pressed() -> void:
	jump.modulate.a = 0.75
	
func _on_jump_released() -> void:
	jump.modulate.a = 1




func _on_shoot_pressed() -> void:
	shoot.modulate.a = 0.75

func _on_shoot_released() -> void:
	shoot.modulate.a = 1




func _on_swing_pressed() -> void:
	swing.modulate.a = 0.75

func _on_swing_released() -> void:
	swing.modulate.a = 1




func _on_pause_pressed() -> void:
	pause.modulate.a = 0.75

func _on_pause_released() -> void:
	pause.modulate.a = 1

	menus_game.visible = true
	menu_pause.visible = true
	Engine.time_scale = 0
