class_name Player
extends CharacterBody2D


@onready var color_rect = $ColorRect

var bounds : Rect2i


func _ready() -> void:
	bounds = Rect2i(Vector2i(200, 200), Vector2i(400, 400))
	#await get_tree().create_timer(0.5).timeout
	#scale("right", "expand", 150)
	#await get_tree().create_timer(0.5).timeout
	#scale("down", "expand", 200)
	#await get_tree().create_timer(0.5).timeout
	#scale("left", "contract", 150)


func _process(_delta: float) -> void:
	color_rect.size = bounds.size


func scale(direction:String, type:String, amount:int):
	match direction:
		"left" when type == "expand":
			bounds.position.x -= amount
		"left" when type == "contract":
			bounds.size.x -= amount
		"right" when type == "expand":
			bounds.size.x += amount
		"right" when type == "contract":
			bounds.position.x += amount
		"up" when type == "expand":
			bounds.position.y -= amount
		"up" when type == "contract":
			bounds.size.y -= amount
		"down" when type == "expand":
			bounds.size.y += amount
		"down" when type == "contract":
			bounds.position.y -= amount
