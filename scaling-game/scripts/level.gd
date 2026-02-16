class_name Level
extends Node2D

@export var player : Player
@onready var grid : TileMapLayer = $Grid
@export var level_bounds : Rect2i = Rect2i(0, 0, 0, 0)

@export var player: Player
@onready var grid: TileMapLayer = $Grid
@export var level_bounds: Rect2i = Rect2i(0, 0, 0, 0)

func has_wall(coords: Vector2i) -> bool:
	return grid.get_cell_source_id(coords) != -1

func is_invalid(coords: Vector2i) -> bool:
	return has_wall(coords) or !level_bounds.has_point(coords)

func _input(event):
	if (event.is_action_pressed("up")):
		var y: int = player.bounds.position.x
		var stopped: bool = false
		while !stopped:
			y -= 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		y += 1
		if (y == player.bounds.position.x):
			# shrink
			pass
		else:
			pass
		pass
	if (event.is_action_pressed("left")):
		pass
	if (event.is_action_pressed("right")):
		pass
	if (event.is_action_pressed("down")):
		pass
