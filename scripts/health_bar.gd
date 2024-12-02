extends ProgressBar

var has_been_init:= false 

var health = 0:
	set(new_health):
		health = min(max_value, new_health)
		value = new_health

func _init_health(init_health):
	has_been_init = true
	health 		= init_health
	max_value 	= init_health
	value		= init_health
