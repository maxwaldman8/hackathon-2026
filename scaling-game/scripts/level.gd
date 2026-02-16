extends Node2D

@export var player: Node2D
@onready var grid: TileMapLayer = $Grid
@export var level_bounds: Rect2i = Rect2i(0, 0, 0, 0)

func square_has_wall(coords: Vector2i) -> bool:
	grid.get_cell_source_id(coords)
	

func _input(event):
	if (event.is_action_pressed("up")):
		
		pass
	if (event.is_action_pressed("left")):
		pass
	if (event.is_action_pressed("right")):
		pass
	if (event.is_action_pressed("down")):
		pass
