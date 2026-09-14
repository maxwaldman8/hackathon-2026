class_name Box
extends Node2D

var lerping: bool = false
var lerp_time: float = 0.1
var lerp_progress: float = 0.0
var original_pos: Vector2
var lerp_to_pos: Vector2

func move(new_pos: Vector2i):
	lerping = true
	original_pos = position
	lerp_to_pos = new_pos

func _process(delta: float) -> void:
	if lerping:
		lerp_progress += delta
		if lerp_progress >= lerp_time:
			lerping = false
			position = lerp_to_pos
			lerp_progress = 0.0
		else:
			position = Vector2(lerpf(original_pos.x, lerp_to_pos.x, lerp_progress / lerp_time), lerpf(original_pos.y, lerp_to_pos.y, lerp_progress / lerp_time))
