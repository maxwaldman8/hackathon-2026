class_name Level
extends Node2D

@export var player : Player
@onready var grid : TileMapLayer = $Grid
@export var level_bounds : Rect2i = Rect2i(0, 0, 0, 0)


func has_wall(coords: Vector2i) -> bool:
	return grid.get_cell_source_id(coords) != -1

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
			player.scale("up", "contract", player.bounds.size.y - 1)
		else:
			player.scale("up", "expand", abs(player.bounds.position.y - y))
	if (event.is_action_pressed("left")):
		pass
	if (event.is_action_pressed("right")):
		pass
	if (event.is_action_pressed("down")):
		var y: int = player.bounds.position.y + player.bounds.size.y
		var stopped: bool = false
		while !stopped:
			y += 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
		y -= 1
		if (y == player.bounds.position.y + player.bounds.size.y):
			player.scale("down", "contract", player.bounds.size.y - 1)
		else:
			player.scale("down", "expand", abs(player.bounds.position.y + player.bounds.size.y - y))
