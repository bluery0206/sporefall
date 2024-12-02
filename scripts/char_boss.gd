extends Area2D

@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_player_timer: Timer = $Timers/DamagePlayerTimer
@onready var collision_detector_right: RayCast2D = $CollisionDetectorRight
@onready var collision_detector_left: RayCast2D = $CollisionDetectorLeft
@onready var collision_detector_down: RayCast2D = $CollisionDetectorDown
@onready var collision_detector_inside: RayCast2D = $CollisionDetectorInside
@onready var damage_text_position: Node2D = $DamageTextPosition
@onready var get_direction_timer: Timer = $Timers/GetDirectionTimer
@onready var growl_1: AudioStreamPlayer2D = $"Sounds/Growl-1"
@onready var growl_2: AudioStreamPlayer2D = $"Sounds/Growl-2"
@onready var growl_3: AudioStreamPlayer2D = $"Sounds/Growl-3"
@onready var death: AudioStreamPlayer2D = $Sounds/Death
@onready var damage_timer: Timer = $DamageZone/DamageTimer

@export var max_health  := 1000
@export var max_atk_damage  := 50
@export var downforce  	:= 100
@export var max_speed  	:= 40
@export var jump_velocity  	:= 300
	
var direction := -1
var is_alive  := true
var is_hurt   := false
var is_attack := false

var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.health = health
	
		if health <= 0:
			is_alive = false
			death.play_random_pitch()
			animation_player.play("death")
			Globals.player_score += max_health
			
		var rand_audio = get_random_size(1, 1, 1)
		match rand_audio:
			0:
				growl_1.play_random_pitch()
			1: 
				growl_2.play_random_pitch()
			_:
				growl_3.play_random_pitch()
var atk_damage
var speed
var player

func _ready() -> void:
	direction 	= 1 if randi_range(0, 1) == 1 else -1
	sprite_animation.flip_h = true if direction == -1 else false
			
	var new_scale = 3
	sprite_animation.speed_scale = randf_range(0.25, 0.5)
	
	# have hikm different attacks
	atk_damage 	= randi_range(int(max_atk_damage * 0.9), max_atk_damage)
	
	speed = randi_range(20, 30)
	scale = Vector2(new_scale, new_scale)
			
	#print("random_size: ",random_size ,", atk_damage: ",atk_damage ,", health: ",health ,", speed: ",speed ,", speed_scale: ",sprite_animation.speed_scale)
	health_bar._init_health(health)
	
func get_atk_damage():
	return randi_range(int(max_atk_damage * 0.9), max_atk_damage)
	
func apply_damage(amount: int, is_critical:bool) -> void:
	health -= amount
	
	DamageText.display_number(amount, damage_text_position.global_position, is_critical)
	is_hurt = true
	damage_player_timer.start()
	
	#print(self.name, " health:", health, " amount:", amount)
	
func _on_damage_player_timer_timeout() -> void:
	is_hurt = false
	
func _process(delta: float) -> void:
	if collision_detector_right.is_colliding():
		direction		= -1
		sprite_animation.flip_h	= true
		
	if collision_detector_left.is_colliding():
		direction		= 1
		sprite_animation.flip_h	= false
		
	if not collision_detector_down.is_colliding() and not collision_detector_inside.is_colliding():
		position.y -= -downforce * delta
	
	if collision_detector_inside.is_colliding():
		position.y += -jump_velocity * delta
	
	if is_alive:
		if is_hurt:
			sprite_animation.play("hurt")
		elif is_attack:
			sprite_animation.play("attack")
		else:
			sprite_animation.play("default")
	else:
		direction = 0
		sprite_animation.speed_scale = 1
		sprite_animation.play("death")

	position.x += direction * speed * delta
	
func set_direction(value: int) -> void:
	direction = value
	sprite_animation.flip_h = true if direction == -1 else false

func is_attacking(status: bool):
	is_attack = status

func get_random_size(s_pct:int, m_pct:int, l_pct:int):
	var weights = [s_pct, m_pct, l_pct]
	var all = []
	for idx in range(len(weights)):
		for perc in range(weights[idx]):
			all.append(idx)
			
	all.shuffle()
	
	return all[randi_range(0, all.size()-1)]


func _on_player_detection_body_entered(_body: Node2D) -> void:
	set_direction(-1 if Globals.player_pos.x - position.x < 0 else 1 )
	get_direction_timer.start()

func _on_player_detection_body_exited(_body: Node2D) -> void:
	set_direction(-1 if Globals.player_pos.x - position.x < 0 else 1 )
	get_direction_timer.stop()

func _on_get_direction_timer_timeout() -> void:
	set_direction(-1 if Globals.player_pos.x - position.x < 0 else 1 )
	get_direction_timer.start()






func _on_body_entered(body: Node2D) -> void:
	if (
		not body.has_method("apply_damage") or
		body.name in name
	):
		return
	
	is_attacking(true)
			
	player = body
		
	body.apply_damage(atk_damage)
	damage_timer.start()

func _on_damage_timer_timeout() -> void:
	player.apply_damage(atk_damage)
	damage_timer.start()


func _on_body_exited(_body: Node2D) -> void:
	is_attacking(false)
	
	damage_timer.stop()
