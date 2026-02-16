extends Node

signal content_finished_loading(content)

var loading_screen : LoadingScreen
var _loading_screen_scene : PackedScene = preload("res://scenes/loading_screen.tscn")
var _content_path : String
var _load_progress_timer : Timer
var _transition_type : String

func _ready() -> void:
	content_finished_loading.connect(on_content_finished_loading)

func load_new_scene(content_path:String, transition_type:String):
	_transition_type = transition_type
	if loading_screen != null:
		await loading_screen.anim_player.animation_finished
		loading_screen = null
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition(_transition_type)
	_load_content(content_path)

func _load_content(content_path:String):
	await loading_screen.anim_player.animation_finished
	_content_path = content_path
	var _loader = ResourceLoader.load_threaded_request(content_path)
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(monitor_load_status)
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()

func monitor_load_status():
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())

func on_content_finished_loading(content):
	var outgoing_scene = get_tree().current_scene
	outgoing_scene.queue_free()
	get_tree().root.call_deferred("add_child", content)
	get_tree().set_deferred("current_scene", content)
	loading_screen.finish_transition(_transition_type)
	await loading_screen.anim_player.animation_finished
	loading_screen = null
