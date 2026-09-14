class_name LoadingScreen
extends CanvasLayer

signal transition_in_complete

@onready var anim_player = $AnimationPlayer

func start_transition(transition_type:String):
	anim_player.play(transition_type)

func finish_transition(transition_type:String):
	anim_player.play(transition_type.replace("to", "from"))
	await anim_player.animation_finished
	queue_free()

func report_midpoint():
	transition_in_complete.emit()
