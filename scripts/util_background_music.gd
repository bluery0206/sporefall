extends AudioStreamPlayer2D

var current_track: AudioStream = null
var fade_duration: float = 1.0  # Duration of the fade in seconds

func play_music(track: AudioStream):
	if current_track == track:
		return  # Do nothing if the same track is already playing
	if current_track != null:
		await fade_out()  # Fade out the current track
		
	if current_track != track:
		current_track = track
		stop()
		stream = current_track
		volume_db = -80  # Start at a very low volume
		play()
		await fade_in()  # Fade in the new track
		bus = "Bgm"

func stop_music():
	stop()
	current_track = null

func fade_out():
	while volume_db > -80:
		volume_db -= 2  # Adjust step size for smoothness
		get_tree().create_timer(0.05)

func fade_in():
	while volume_db < 0:
		volume_db += 2  # Adjust step size for smoothness
		get_tree().create_timer(0.05)


# Home Screen
#@onready var bg_music: AudioStream = preload("res://audio/home_theme.ogg")
#
#func _ready():
	#MusicManager.play_music(bg_music)  # Assumes the autoload name is `MusicManager`

#Levels
#@onready var bg_music: AudioStream = preload("res://audio/menu_theme.ogg")
#
#func _ready():
	#MusicManager.play_music(bg_music)

# gameplay
#@onready var bg_music: AudioStream = preload("res://audio/gameplay_theme.ogg")
#
#func _ready():
	#MusicManager.play_music(bg_music)
