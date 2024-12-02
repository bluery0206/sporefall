extends Area2D

@onready var damage_timer: Timer = $DamageTimer
@export var init_atk_damage: int = 20

var parent
var player
var atk_damage

func _ready() -> void:
	parent = get_parent()
	
	#print(name, ": ", parent)
	
	if parent.has_method("get_atk_damage"):
		atk_damage = parent.get_atk_damage()  
		

		#print("parent.get_atk_damage(): ", enemy.get_atk_damage()  )
	
func _on_body_entered(body: Node2D) -> void:
	if (
		not body.has_method("apply_damage") or
		body.name in name
	):
		return
	
	if parent.has_method("is_attacking"):	parent.is_attacking(true)
	
	if not parent.has_method("get_atk_damage"):
		atk_damage = body.get_health()  
			
	player = body
		
	body.apply_damage(atk_damage)
	damage_timer.start()

func _on_damage_timer_timeout() -> void:
	player.apply_damage(atk_damage)
	damage_timer.start()


func _on_body_exited(_body: Node2D) -> void:
	if parent.has_method("is_attacking"):	parent.is_attacking(false)
	
	damage_timer.stop()
