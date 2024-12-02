extends Area2D

@onready var despawn_timer: Timer = $DespawnTimer

@export var speed 			:= 750
@export var can_damage  	:= true
@export var init_atk_damage := 15
@export var crit_chance 	:= 50
@export var atk_dmg_multplr := 1.5

const ENEMIES = ["Enemy", "Boss"]

var is_critical	: bool
var direction	: int

var atk_damage

func _ready() -> void:
	atk_damage = init_atk_damage

func _process(delta: float) -> void:
	position.x += direction * speed * delta

func _despawn() -> void:
	self.call_deferred("queue_free")
	self.queue_free()

func get_atk_damage():
	return atk_damage

func _on_area_entered(area: Area2D) -> void:
	var area_name = area.name.substr(0, 3)
	
	for enem_name in ENEMIES:
		if area_name.to_lower() in enem_name.to_lower():
			area.apply_damage(atk_damage, is_critical)
			self.call_deferred("queue_free")
			self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "TileMap" in body.name:
		self.call_deferred("queue_free")
		self.queue_free()
