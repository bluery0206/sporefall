extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func flip_animation_h(status: bool):
	animated_sprite_2d.play("shoot")
	animated_sprite_2d.flip_h = status
