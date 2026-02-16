class_name Player
extends Node2D

@export var level : Level

@onready var grid : TileMapLayer = level.get_node("Grid")
@onready var bounds : Rect2i = Rect2i(Vector2i(position / Vector2(grid.tile_set.tile_size)), scale)

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	position = bounds.position * grid.tile_set.tile_size
	scale = bounds.size

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
	print(bounds)
