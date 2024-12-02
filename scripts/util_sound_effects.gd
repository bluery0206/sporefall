extends AudioStreamPlayer2D

func play_random_pitch():
	if is_inside_tree():
		pitch_scale = randf_range(0.75, 1.25)
		play()
