extends Control


func _ready() -> void:
	var menu_music: AudioStream = load("res://assets/music/Menu music.wav")
	Music.get_node("AudioStreamPlayer2D").stream = menu_music
	Music.get_node("AudioStreamPlayer2D").volume_db = -7
	Music.get_node("AudioStreamPlayer2D").play()



func _on_play_button_pressed() -> void:
	SceneManager.load_new_scene("res://scenes/levels/hub_level.tscn", "fade_to_black")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	SceneManager.load_new_scene("res://scenes/credits.tscn", "fade_to_black")
