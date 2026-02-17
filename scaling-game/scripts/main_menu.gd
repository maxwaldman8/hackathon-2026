extends Control


func _ready() -> void:
	var menu_music: AudioStream = load("res://assets/music/Menu music.wav")
	Music.get_node("AudioStreamPlayer2D").stream = menu_music
	Music.get_node("AudioStreamPlayer2D").play()
