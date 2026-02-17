class_name Player
extends Node2D

@export var level : Level

@onready var grid : TileMapLayer = level.get_node("Grid")
@onready var bounds : Rect2i = Rect2i(Vector2i(position / Vector2(grid.tile_set.tile_size)), scale)
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var lerping: bool = false
var lerp_time: float = 0.1
var lerp_progress: float = 0.0
var original_pos: Vector2
var lerp_to_pos: Vector2
var original_scale: Vector2
var lerp_to_scale: Vector2

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
			scale = lerp_to_scale
			lerp_progress = 0.0
		else:
			position = Vector2(lerpf(original_pos.x, lerp_to_pos.x, lerp_progress / lerp_time), lerpf(original_pos.y, lerp_to_pos.y, lerp_progress / lerp_time))
			scale = Vector2(lerpf(original_scale.x, lerp_to_scale.x, lerp_progress / lerp_time), lerpf(original_scale.y, lerp_to_scale.y, lerp_progress / lerp_time))
	$Sprite2D.global_scale = 2 * Vector2(min(scale.x, scale.y), min(scale.x, scale.y))
	if level.is_main:
		$Sprite2D.texture = load("res://assets/textures/Face1.png")
		$ColorRect.color = Color("#999999")
	else:
		$Sprite2D.texture = load("res://assets/textures/Face2.png")
		$ColorRect.color = Color("#ffffffdd")


func scale_bounds(direction:String, type:String, amount:int):
	match direction:
		"left" when type == "expand":
			bounds.position.x -= amount
			bounds.size.x += amount
		"left" when type == "contract":
			bounds.size.x -= amount
		"right" when type == "expand":
			bounds.size.x += amount
		"right" when type == "contract":
			bounds.position.x += amount
			bounds.size.x = 1
		"up" when type == "expand":
			bounds.position.y -= amount
			bounds.size.y += amount
		"up" when type == "contract":
			bounds.size.y -= amount
		"down" when type == "expand":
			bounds.size.y += amount
		"down" when type == "contract":
			bounds.position.y += amount
			bounds.size.y = 1
	lerping = true
	original_pos = position
	original_scale = scale
	lerp_to_pos = bounds.position * grid.tile_set.tile_size
	lerp_to_scale = bounds.size
	sound.pitch_scale = 1 if (amount >= 0) else 1.0 / pow(amount, 0.125) * (1.25 if type == "contract" else 1.0)
	if amount != 0:
		sound.play()
