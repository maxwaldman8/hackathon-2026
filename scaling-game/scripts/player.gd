extends CharacterBody2D


@onready var color_rect = $ColorRect

var rectangle : Rect2i


func _ready() -> void:
	rectangle = Rect2i(Vector2i(200, 200), Vector2i(400, 400))
	#await get_tree().create_timer(0.5).timeout
	#scale("right", "expand", 150)
	#await get_tree().create_timer(0.5).timeout
	#scale("down", "expand", 200)
	#await get_tree().create_timer(0.5).timeout
	#scale("left", "contract", 150)


func _process(_delta: float) -> void:
	color_rect.size = rectangle.size


func scale(direction:String, type:String, amount:int):
	match direction:
		"left" when type == "expand":
			rectangle.position.x -= amount
		"left" when type == "contract":
			rectangle.size.x -= amount
		"right" when type == "expand":
			rectangle.size.x += amount
		"right" when type == "contract":
			rectangle.position.x += amount
		"up" when type == "expand":
			rectangle.position.y -= amount
		"up" when type == "contract":
			rectangle.size.y -= amount
		"down" when type == "expand":
			rectangle.size.y += amount
		"down" when type == "contract":
			rectangle.position.y -= amount
