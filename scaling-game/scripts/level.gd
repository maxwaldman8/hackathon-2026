extends Node2D

@export var player: Player
@onready var grid: TileMapLayer = $Grid
@export var level_bounds: Rect2i = Rect2i(0, 0, 0, 0)

func has_wall(coords: Vector2i) -> bool:
	return grid.get_cell_source_id(coords) != -1

func is_invalid(coords: Vector2i) -> bool:
	return has_wall(coords) or !level_bounds.has_point(coords)

func _input(event):
	if (event.is_action_pressed("up")):
		for x in range(player.position.x, player.position.x + player.)
		pass
	if (event.is_action_pressed("left")):
		pass
	if (event.is_action_pressed("right")):
		pass
	if (event.is_action_pressed("down")):
		pass
