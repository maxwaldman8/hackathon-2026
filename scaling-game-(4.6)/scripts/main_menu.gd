extends Control


func _ready() -> void:
	Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Menu music.wav")
	Music.get_node("AudioStreamPlayer2D").volume_db = -7
	Music.get_node("AudioStreamPlayer2D").play()



func _on_play_button_pressed() -> void:
	Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Pop.mp3")
	Music.get_node("AudioStreamPlayer2D").play()
	SceneManager.load_new_scene("res://scenes/levels/hub_level.tscn", "fade_to_black")


func _on_quit_button_pressed() -> void:
	Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Pop.mp3")
	Music.get_node("AudioStreamPlayer2D").play()
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Pop.mp3")
	Music.get_node("AudioStreamPlayer2D").play()
	SceneManager.load_new_scene("res://scenes/credits.tscn", "fade_to_black")
