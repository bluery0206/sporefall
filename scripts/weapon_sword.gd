extends Area2D

@onready var sword_animation: AnimationPlayer = $SwordAnimation
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing: AudioStreamPlayer2D = $Sounds/Swing
@onready var swing_crit: AudioStreamPlayer2D = $Sounds/SwingCrit

@export var can_damage 	:= true
@export var init_atk_damage := 20
@export var crit_chance		= 75
@export var atk_dmg_multplr := 1.75

var atk_damage 		= init_atk_damage

var prev_position 	:= position

var is_hit: bool
var is_critical: bool
var flip: bool

func get_atk_damage():
	return atk_damage

func _on_area_entered(area: Area2D) -> void:
	#print(self.name,  " area.name:", area.name)
	if area.has_method("apply_damage"):
		is_hit = true
		area.apply_damage(atk_damage, is_critical)

func random_attack_animation():
	var anim = ["up", "down"]
	var random_anim = randi_range(0, 1)
		
	animated_sprite_2d.flip_h = flip
	animated_sprite_2d.play(anim[random_anim])
	
func flip_animation_h(status: bool):
	flip = status

func play_audio():
	if is_critical and is_hit:
		swing_crit.play_random_pitch()
	else:
		swing.play_random_pitch()

func _on_area_exited(_area: Area2D) -> void:
	is_hit = false
