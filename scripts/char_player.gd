extends CharacterBody2D

@onready var health_bar: ProgressBar = $HealthBar
@onready var attack_location_right: Marker2D = $AttackLocationMarkers/AttackLocationRight
@onready var attack_location_left: Marker2D = $AttackLocationMarkers/AttackLocationLeft
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $Timers/ShootInterval
@onready var swing_timer: Timer = $Timers/SwingInterval
@onready var damage_text_position: Node2D = $DamageTextPosition
@onready var enemy_detection: Area2D = $EnemyDetection
@onready var update_position_timer: Timer = $Timers/UpdatePositionTimer
@onready var heal_timer: Timer = $Timers/HealTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 175.0
const JUMP_VELOCITY = -275.0

@export var max_health := 100
@export var heal := 5

var direction = 0
var is_hurt := false
var is_shoot := false
var is_swing := false
var is_alive := true
var can_shoot := true
var can_swing := true

var health:
	set(value):
		health = clamp(value, 0, 100)
		health_bar.health = health
		
func _ready() -> void:
	health_bar._init_health(max_health)
	health 		= max_health

func _physics_process(delta: float) -> void:
	if is_alive:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		direction = Input.get_axis("left", "right")

		velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swing") and can_swing:
		swing()
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()
		
func _process(_delta: float) -> void:
	update_sprite_animation()
	update_player_sprite_direction()
	Globals.player_pos = position
		
func update_player_sprite_direction():
	# Make character face right
	if direction > 0: 
		sprite_animation.flip_h = false 
		
	# Make character face left
	if direction < 0: 
		sprite_animation.flip_h = true 
		
func update_sprite_animation():
	if is_alive:
		if is_hurt:
			if direction == 0:
				sprite_animation.play("idle-hurt")
			else:
				sprite_animation.play("run-hurt")
		elif is_shoot:
			sprite_animation.play("shoot")
		elif is_swing:
			sprite_animation.play("swing")
		elif is_on_floor():
			if direction == 0:
				sprite_animation.play("idle")
			else:
				sprite_animation.play("run")
		else:
			sprite_animation.play("jump")
	else:
		can_shoot = false
		can_swing = false
		
		Globals.prev_scene = get_parent().scene_file_path
		sprite_animation.play("death")
		animation_player.play("death")
		
		
func get_health():
	return health
		
func swing():
	var sword = load("res://scenes/weapon_sword.tscn").instantiate()
	
	swing_timer.start()
	add_child(sword)
	
	is_swing 			= true 
	can_swing			= false
	
	if is_on_floor():
		sword.atk_damage = sword.init_atk_damage  
	else:
		var chance = randi_range(0, 100)
		if chance < sword.crit_chance:
			sword.atk_damage *= sword.atk_dmg_multplr
			sword.is_critical = true

	if sprite_animation.flip_h: 
		sword.position = attack_location_left.position + Vector2(-3, -5)
		#sword.position = attack_location_left.global_position + Vector2(-20, 0)
	else:
		sword.position = attack_location_right.position + Vector2(3, -5)
		#sword.position = attack_location_right.global_position + Vector2(20, 0)
		
	sword.flip_animation_h(sprite_animation.flip_h)
	sword.sword_animation.play("swing")
		
		
func _on_swing_interval_timeout() -> void:
	is_swing = false
	can_swing = true
	
func shoot():
	var bullet 	= load("res://scenes/weapon_bullet.tscn").instantiate()
	var gun  	= load("res://scenes/weapon_gun.tscn").instantiate()
	
	shoot_timer.start()
	get_parent().add_child(bullet)
	add_child(gun)
	
	is_shoot = true
	can_shoot = false
	
	if is_on_floor():
		bullet.atk_damage = bullet.init_atk_damage  
	else:
		if randi_range(0, 100) < bullet.crit_chance:
			bullet.atk_damage *= bullet.atk_dmg_multplr
			bullet.is_critical = true
	 
	if sprite_animation.flip_h: 
		bullet.position = attack_location_left.global_position
		bullet.direction = -1
		gun.position = attack_location_left.position + Vector2(-3, -5)
	else:
		bullet.position = attack_location_right.global_position
		bullet.direction = 1
		gun.position = attack_location_right.position + Vector2(3, -5)
		
	gun.flip_animation_h(sprite_animation.flip_h)
	gun.animation_player.play("shoot")
	
func _on_shoot_interval_timeout() -> void:
	is_shoot = false
	can_shoot = true
	

func apply_damage(amount: int) -> void:
	health -= amount
	
	#print(self.name, " health:", health, " amount:", amount)
	
	if health <= 0 :
		is_alive = false
		
	DamageText.display_number(amount, damage_text_position.global_position)








func _on_heal_timer_timeout() -> void: 
	if health != max_health:
		health += heal
		DamageText.display_number(heal, damage_text_position.global_position, false, true)





# Enemy detection
# -	Update position only when enemy is found.
# - Updates in intervals

func _on_update_position_timer_timeout() -> void:
	Globals.player_pos = position
	update_position_timer.start()

func _on_enemy_detection_area_entered(_area: Area2D) -> void:
	Globals.player_pos = position
	update_position_timer.stop()

func _on_enemy_detection_area_exited(_area: Area2D) -> void:
	Globals.player_pos = position
	update_position_timer.start()

func go_to_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)

func change_time_scale(value:float=1.0):
		Engine.time_scale = value
