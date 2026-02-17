class_name Level
extends Node2D

@export var is_main : bool
@export var player : Player
@onready var grid : TileMapLayer = $Grid
@onready var boxes = $Boxes.get_children()
@export var level_bounds : Rect2i = Rect2i(0, 0, 0, 0)

var target_bounds : Dictionary
var level_targets : Array[Vector2i]
var is_done : bool = false
var level_labels : Array[Node]
var finished_levels : Array[Node]
var disabled : bool = false

const DIRECTIONS : Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const TAGS : Dictionary = {
	Vector2i(17, 32): 1, Vector2i(17, 24): 2, Vector2i(21, 26): 3,
	Vector2i(23, 20): 4, Vector2i(42, 24): 5, Vector2i(42, 22): 6,
	Vector2i(39, 24): 7, Vector2i(36, 13): 8, Vector2i(33, 10): 9,
	Vector2i(40, 10): 10, Vector2i(27, 8): 11, Vector2i(5, 3): 12,
}

func _ready_labels():
	if not is_main:
		return
	level_labels = $LevelEnterLabels.get_children()
	finished_levels = $FinishedLevels.get_children()
	for label in level_labels:
		label.visible = false

func _ready() -> void:
	_ready_labels()
	for item in finished_levels:
		item.visible = false
	
	if is_main:
		if SavedLevelInfo.solved_levels.find(9) != -1 or SavedLevelInfo.solved_levels.find(10) != -1:
			Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Hub Music 3.wav")
		elif SavedLevelInfo.solved_levels.find(5) != -1 or SavedLevelInfo.solved_levels.find(6) != -1:
			Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Hub Music 2.wav")
		else:
			Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Hub Music 1.wav")
		Music.get_node("AudioStreamPlayer2D").volume_db = 18
	else:
		if Music.get_node("AudioStreamPlayer2D").stream.resource_path != "res://assets/music/Blueprints.wav":
			Music.get_node("AudioStreamPlayer2D").stream = load("res://assets/music/Blueprints.wav")
			Music.get_node("AudioStreamPlayer2D").volume_db = 0
	if !Music.get_node("AudioStreamPlayer2D").playing:
		Music.get_node("AudioStreamPlayer2D").play()
	# Future floodfill for target collection
	var used = grid.get_used_cells()
	var new_used = []
	for tile in used:
		if grid.get_cell_alternative_tile(tile) == 3:
			new_used.append(tile)
			level_targets.append(tile)
	used = new_used
	while len(used) > 0:
		# Getting the group
		var unchecked : Array[Vector2i] = [used.pop_front()]
		var checked : Array[Vector2i] = []
		var level_num_tag : int
		while len(unchecked) > 0:
			var next : Vector2i = unchecked.pop_front()
			var surroundings = DIRECTIONS.map(func(x): return x + next)
			if next in TAGS.keys() and is_main:
				level_num_tag = TAGS[next]
			for adj in surroundings:
				if adj in used:
					unchecked.append(adj)
					used.erase(adj)
			checked.append(next)
		
		# Adjusting solids (completed levels)
		
		if level_num_tag in SavedLevelInfo.solved_levels and is_main:
			print(SavedLevelInfo.solved_levels)
			for tile in checked:
				grid.set_cell(tile, 3, Vector2i(0, 0), 1)
			grid.update_internals()
			finished_levels[level_num_tag - 1].visible = true
		
		# Converting group to rect
		var min_x : int = 1000
		var min_y : int = 1000
		var max_x : int = -1
		var max_y : int = -1
		for tile in checked:
			min_x = min(min_x, tile.x)
			min_y = min(min_y, tile.y)
			max_x = max(max_x, tile.x)
			max_y = max(max_y, tile.y)
		var group = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
		
		# Checking for quitting level
		if SavedLevelInfo.did_just_quit_level[0]:
			# Position to level
			pass
		
		target_bounds[group] = level_num_tag
		SavedLevelInfo.did_just_quit_level = [false, 0]

func has_wall(coords: Vector2i) -> bool:
	return grid.get_cell_alternative_tile(coords) == 1

func has_box(coords: Vector2i) -> bool:
	for box in boxes:
		@warning_ignore("integer_division")
		if Vector2i(box.position) / grid.tile_set.tile_size == coords:
			return true
	return false

func get_box_at_pos(coords: Vector2i) -> Box:
	for box in boxes:
		@warning_ignore("integer_division")
		if Vector2i(box.position) / grid.tile_set.tile_size == coords:
			return box
	return null

func is_invalid(coords: Vector2i) -> bool:
	return has_wall(coords) or !level_bounds.has_point(coords)

func _input(event):
	if disabled:
		return
	if event.is_action_pressed("up"):
		if player.lerping:
			return
		var old_box_positions: Array[Vector2i] = []
		for box in boxes:
			old_box_positions.append(box.position)
		var max_y: int = -1
		for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
			var y: int = player.bounds.position.y
			var stopped: bool = false
			var pushed_boxes: Array[Vector2i] = []
			while !stopped:
				y -= 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.push_front(Vector2i(x, y))
			y += 1
			if y + pushed_boxes.size() > max_y:
				max_y = y + pushed_boxes.size()
		for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
			var y: int = player.bounds.position.y
			var stopped: bool = false
			var pushed_boxes_indices: Array[int] = []
			var pushed_boxes: Array[Box] = []
			while !stopped:
				y -= 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				var maybe_box = get_box_at_pos(Vector2i(x, y))
				if maybe_box != null:
					pushed_boxes.push_front(maybe_box)
					pushed_boxes_indices.push_front(old_box_positions.find(Vector2i(x, y) * grid.tile_set.tile_size))
			y += 1
			var counter = 0
			var i = player.bounds.position.y
			while i > max_y - 1 - counter:
				if has_box(Vector2i(x, i)):
					counter += 1
				i -= 1
			for j in range(0, counter):
				var new_position = Vector2(pushed_boxes[pushed_boxes.size() - 1 - j].position.x, (max_y - 1 - j) * grid.tile_set.tile_size.y)
				pushed_boxes[pushed_boxes.size() - 1 - j].position = old_box_positions[pushed_boxes_indices[pushed_boxes.size() - 1 - j]]
				pushed_boxes[pushed_boxes.size() - 1 - j].move(new_position)
		if max_y == player.bounds.position.y:
			player.scale_bounds("up", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("up", "expand", abs(player.bounds.position.y - max_y))
	if event.is_action_pressed("left"):
		if player.lerping:
			return
		var old_box_positions: Array[Vector2i] = []
		for box in boxes:
			old_box_positions.append(box.position)
		var max_x: int = -1
		for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
			var x: int = player.bounds.position.x
			var stopped: bool = false
			var pushed_boxes: Array[Vector2i] = []
			while !stopped:
				x -= 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.push_front(Vector2i(x, y))
			x += 1
			if x + pushed_boxes.size() > max_x:
				max_x = x + pushed_boxes.size()
		for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
			var x: int = player.bounds.position.x
			var stopped: bool = false
			var pushed_boxes_indices: Array[int] = []
			var pushed_boxes: Array[Box] = []
			while !stopped:
				x -= 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				var maybe_box = get_box_at_pos(Vector2i(x, y))
				if maybe_box != null:
					pushed_boxes.push_front(maybe_box)
					pushed_boxes_indices.push_front(old_box_positions.find(Vector2i(x, y) * grid.tile_set.tile_size))
			x += 1
			var counter = 0
			var i = player.bounds.position.x
			while i > max_x - 1 - counter:
				if has_box(Vector2i(i, y)):
					counter += 1
				i -= 1
			for j in range(0, counter):
				var new_position = Vector2((max_x - 1 - j) * grid.tile_set.tile_size.x, pushed_boxes[pushed_boxes.size() - 1 - j].position.y)
				pushed_boxes[pushed_boxes.size() - 1 - j].position = old_box_positions[pushed_boxes_indices[pushed_boxes.size() - 1 - j]]
				pushed_boxes[pushed_boxes.size() - 1 - j].move(new_position)
		if max_x == player.bounds.position.x:
			player.scale_bounds("left", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("left", "expand", abs(player.bounds.position.x - max_x))
	if event.is_action_pressed("right"):
		if player.lerping:
			return
		var old_box_positions: Array[Vector2i] = []
		for box in boxes:
			old_box_positions.append(box.position)
		var min_x: int = level_bounds.position.x + level_bounds.size.x
		for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
			var x: int = player.bounds.position.x + player.bounds.size.x - 1
			var stopped: bool = false
			var pushed_boxes: Array[Vector2i] = []
			while !stopped:
				x += 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.push_front(Vector2i(x, y))
			x -= 1
			if x - pushed_boxes.size() < min_x:
				min_x = x - pushed_boxes.size()
		for y in range(player.bounds.position.y, player.bounds.position.y + player.bounds.size.y):
			var x: int = player.bounds.position.x + player.bounds.size.x - 1
			var stopped: bool = false
			var pushed_boxes_indices: Array[int] = []
			var pushed_boxes: Array[Box] = []
			while !stopped:
				x += 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				var maybe_box = get_box_at_pos(Vector2i(x, y))
				if maybe_box != null:
					pushed_boxes.push_front(maybe_box)
					pushed_boxes_indices.push_front(old_box_positions.find(Vector2i(x, y) * grid.tile_set.tile_size))
			x -= 1
			var counter = 0
			var i = player.bounds.position.x + player.bounds.size.x - 1
			while i < min_x + 1 + counter:
				if has_box(Vector2i(i, y)):
					counter += 1
				i += 1
			for j in range(0, counter):
				var new_position = Vector2( (min_x + 1 + j) * grid.tile_set.tile_size.x, pushed_boxes[pushed_boxes.size() - 1 - j].position.y)
				pushed_boxes[pushed_boxes.size() - 1 - j].position = old_box_positions[pushed_boxes_indices[pushed_boxes.size() - 1 - j]]
				pushed_boxes[pushed_boxes.size() - 1 - j].move(new_position)
		if min_x == player.bounds.position.x + player.bounds.size.x - 1:
			player.scale_bounds("right", "contract", player.bounds.size.x - 1)
		else:
			player.scale_bounds("right", "expand", abs(player.bounds.position.x + player.bounds.size.x - 1 - min_x))
	if event.is_action_pressed("down"):
		if player.lerping:
			return
		var old_box_positions: Array[Vector2i] = []
		for box in boxes:
			old_box_positions.append(box.position)
		var min_y: int = level_bounds.position.y + level_bounds.size.y
		for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
			var y: int = player.bounds.position.y + player.bounds.size.y - 1
			var stopped: bool = false
			var pushed_boxes: Array[Vector2i] = []
			while !stopped:
				y += 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				if has_box(Vector2i(x, y)):
					pushed_boxes.push_front(Vector2i(x, y))
			y -= 1
			if y - pushed_boxes.size() < min_y:
				min_y = y - pushed_boxes.size()
		for x in range(player.bounds.position.x, player.bounds.position.x + player.bounds.size.x):
			var y: int = player.bounds.position.y + player.bounds.size.y - 1
			var stopped: bool = false
			var pushed_boxes_indices: Array[int] = []
			var pushed_boxes: Array[Box] = []
			while !stopped:
				y += 1
				if is_invalid(Vector2i(x, y)):
					stopped = true
					break
				var maybe_box = get_box_at_pos(Vector2i(x, y))
				if maybe_box != null:
					pushed_boxes.push_front(maybe_box)
					pushed_boxes_indices.push_front(old_box_positions.find(Vector2i(x, y) * grid.tile_set.tile_size))
			y -= 1
			var counter = 0
			var i = player.bounds.position.y + player.bounds.size.y - 1
			while i < min_y + 1 + counter:
				if has_box(Vector2i(x, i)):
					counter += 1
				i += 1
			for j in range(0, counter):
				var new_position = Vector2(pushed_boxes[pushed_boxes.size() - 1 - j].position.x, (min_y + 1 + j) * grid.tile_set.tile_size.y)
				pushed_boxes[pushed_boxes.size() - 1 - j].position = old_box_positions[pushed_boxes_indices[pushed_boxes.size() - 1 - j]]
				pushed_boxes[pushed_boxes.size() - 1 - j].move(new_position)
		if min_y == player.bounds.position.y + player.bounds.size.y - 1:
			player.scale_bounds("down", "contract", player.bounds.size.y - 1)
		else:
			player.scale_bounds("down", "expand", abs(player.bounds.position.y + player.bounds.size.y - 1 - min_y))
	if event.is_action_pressed("reset") and !is_main:
		get_tree().reload_current_scene()
	is_done = _check_finished()
	if is_main:
		if is_done:
			level_labels[target_bounds[player.bounds] - 1].visible = true
		else:
			for label in level_labels:
				label.visible = false
	if not is_main and is_done:
		SceneManager.load_new_scene("res://scenes/levels/hub_level.tscn", "fade_to_black")
		disabled = true
		SavedLevelInfo.solved_levels.append(int(self.scene_file_path))
	if event.is_action_pressed("enter"):
		if not is_main and not is_done:
			SceneManager.load_new_scene("res://scenes/levels/hub_level.tscn", "fade_to_black")
			disabled = true
			SavedLevelInfo.did_just_quit_level = [true, int(self.scene_file_path)]
		elif is_main and is_done:
			SceneManager.load_new_scene("res://scenes/levels/level" + str(target_bounds[player.bounds]) + ".tscn", "fade_to_black")
			disabled = true

func _check_finished():
	if is_main:
		return player.bounds in target_bounds
	var unchecked_targets = level_targets.duplicate()
	for x in range(player.bounds.position.x, player.bounds.end.x):
		for y in range(player.bounds.position.y, player.bounds.end.y):
			var player_pos = Vector2i(x, y)
			if player_pos not in unchecked_targets:
				return false
			unchecked_targets.erase(player_pos)
	if len(unchecked_targets) == 0:
		return true
	for box in boxes:
		@warning_ignore("integer_division")
		var box_coords = Vector2i(box.position) / grid.tile_set.tile_size
		if box_coords in unchecked_targets:
			unchecked_targets.erase(box_coords)
	return len(unchecked_targets) == 0
