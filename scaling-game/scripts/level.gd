class_name Level
extends Node2D

@export var is_main : bool
@export var player : Player
@onready var grid : TileMapLayer = $Grid
@export var level_bounds : Rect2i = Rect2i(0, 0, 0, 0)

var boxes: Array[Vector2i] = []
var targets_bounds : Rect2i
var is_done : bool = false

func _ready() -> void:
	var used = grid.get_used_cells()
	var min_x : int = 1000
	var min_y : int = 1000
	var max_x : int = -1
	var max_y : int = -1
	for tile in used:
		if grid.get_cell_alternative_tile(tile) != 3:
			continue
		min_x = min(min_x, tile.x)
		min_y = min(min_y, tile.y)
		max_x = max(max_x, tile.x)
		max_y = max(max_y, tile.y)
	targets_bounds = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
	print(targets_bounds)

func has_wall(coords: Vector2i) -> bool:
	return grid.get_cell_alternative_tile(coords) == 1

func has_box(coords: Vector2i) -> bool:
	return grid.get_cell_alternative_tile(coords) == 2

func is_invalid(coords: Vector2i) -> bool:
	return has_wall(coords) or !level_bounds.has_point(coords)

func _input(event):
	if event.is_action_pressed("up"):
		var y: int = player.bounds.position.y
		var stopped: bool = false
		var pushed_boxes: Array[Vector2i] = []
		while !stopped:
			y -= 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.append(Vector2i(x, y))
			for box in pushed_boxes:
				if is_invalid(Vector2i(box.x, box.y - 1)):
					stopped = true
					break
				if has_box(Vector2i(box.x, box.y - 1)):
					pushed_boxes.append(Vector2i(box.x, box.y - 1))
			if !stopped:
				pushed_boxes.reverse()
				for i in range(0, pushed_boxes.size()):
					pushed_boxes[i].y -= 1
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y + 1), -1, Vector2i(0, 0), 0)
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y), 0, Vector2i(0, 0), 2)
		y += 1
		if y == player.bounds.position.y:
			player.scale_bounds("up", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("up", "expand", abs(player.bounds.position.y - y))
	if event.is_action_pressed("left"):
		var x: int = player.bounds.position.x
		var stopped: bool = false
		var pushed_boxes: Array[Vector2i] = []
		while !stopped:
			x -= 1
			for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.append(Vector2i(x, y))
			for box in pushed_boxes:
				if is_invalid(Vector2i(box.x - 1, box.y)):
					stopped = true
					break
				if has_box(Vector2i(box.x - 1, box.y)):
					pushed_boxes.append(Vector2i(box.x - 1, box.y))
			if !stopped:
				pushed_boxes.reverse()
				for i in range(0, pushed_boxes.size()):
					pushed_boxes[i].x -= 1
					grid.set_cell(Vector2i(pushed_boxes[i].x + 1, pushed_boxes[i].y), -1, Vector2i(0, 0), 0)
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y), 0, Vector2i(0, 0), 2)
		x += 1
		if x == player.bounds.position.x:
			player.scale_bounds("left", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("left", "expand", abs(player.bounds.position.x - x))
	if event.is_action_pressed("right"):
		var x: int = player.bounds.position.x + player.bounds.size.x - 1
		var stopped: bool = false
		var pushed_boxes: Array[Vector2i] = []
		while !stopped:
			x += 1
			for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.append(Vector2i(x, y))
			for box in pushed_boxes:
				if is_invalid(Vector2i(box.x + 1, box.y)):
					stopped = true
					break
				if has_box(Vector2i(box.x + 1, box.y)):
					pushed_boxes.append(Vector2i(box.x + 1, box.y))
			if !stopped:
				pushed_boxes.reverse()
				for i in range(0, pushed_boxes.size()):
					pushed_boxes[i].x += 1
					grid.set_cell(Vector2i(pushed_boxes[i].x - 1, pushed_boxes[i].y), -1, Vector2i(0, 0), 0)
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y), 0, Vector2i(0, 0), 2)
		x -= 1
		if x == player.bounds.position.x + player.bounds.size.x - 1:
			player.scale_bounds("right", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("right", "expand", abs(player.bounds.position.x + player.bounds.size.x - 1 - x))
	if event.is_action_pressed("down"):
		var y: int = player.bounds.position.y + player.bounds.size.y - 1
		var stopped: bool = false
		var pushed_boxes: Array[Vector2i] = []
		while !stopped:
			y += 1
			for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
						pushed_boxes.append(Vector2i(x, y))
			for box in pushed_boxes:
				if is_invalid(Vector2i(box.x, box.y + 1)):
					stopped = true
					break
				if has_box(Vector2i(box.x, box.y + 1)):
					pushed_boxes.append(Vector2i(box.x, box.y + 1))
			if !stopped:
				pushed_boxes.reverse()
				for i in range(0, pushed_boxes.size()):
					pushed_boxes[i].y += 1
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y - 1), -1, Vector2i(0, 0), 0)
					grid.set_cell(Vector2i(pushed_boxes[i].x, pushed_boxes[i].y), 0, Vector2i(0, 0), 2)
		y -= 1
		if y == player.bounds.position.y + player.bounds.size.y - 1:
			player.scale_bounds("down", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("down", "expand", abs(player.bounds.position.y + player.bounds.size.y - 1 - y))
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if _check_finished() and not is_done:
		is_done = true
		if is_main:
			SceneManager.load_new_scene("res://scenes/levels/level" + str(1) + ".tscn", "fade_to_black")
		else:
			SceneManager.load_new_scene("res://scenes/levels/main_level.tscn", "fade_to_black")

func _check_finished():
	return targets_bounds == player.bounds
