class_name Level
extends Node2D

@export var player : Player
@onready var grid : TileMapLayer = $Grid
@export var level_bounds : Rect2i = Rect2i(0, 0, 0, 0)


func has_wall(coords: Vector2i) -> bool:
	print(grid.get_cell_source_id(coords))
	return grid.get_cell_source_id(coords) == 0


func is_invalid(coords: Vector2i) -> bool:
	return has_wall(coords) or !level_bounds.has_point(coords)


func _input(event):
	if (event.is_action_pressed("up")):
		var y: int = player.bounds.position.y
		var stopped: bool = false
		while !stopped:
			y -= 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		y += 1
		if (y == player.bounds.position.y):
			player.scale_bounds("up", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("up", "expand", abs(player.bounds.position.y - y))
	if (event.is_action_pressed("left")):
		var x: int = player.bounds.position.x
		var stopped: bool = false
		while !stopped:
			x -= 1
			for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		x += 1
		if (x == player.bounds.position.x):
			player.scale_bounds("left", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("left", "expand", abs(player.bounds.position.x - x))
	if (event.is_action_pressed("right")):
		var x: int = player.bounds.position.x + player.bounds.size.x - 1
		var stopped: bool = false
		while !stopped:
			x += 1
			for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		x -= 1
		if (x == player.bounds.position.x + player.bounds.size.x - 1):
			player.scale_bounds("right", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("right", "expand", abs(player.bounds.position.x + player.bounds.size.x - 1 - x))
	if (event.is_action_pressed("down")):
		var y: int = player.bounds.position.y + player.bounds.size.y - 1
		var stopped: bool = false
		while !stopped:
			y += 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		y -= 1
		if (y == player.bounds.position.y + player.bounds.size.y - 1):
			player.scale_bounds("down", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("down", "expand", abs(player.bounds.position.y + player.bounds.size.y - 1 - y))
