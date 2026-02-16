extends CharacterBody2D


@onready var color_rect = $ColorRect

var rectangle : Rect2i


func _ready() -> void:
	rectangle = Rect2i(Vector2i(100, 100), Vector2i(150, 150))


func _process(_delta: float) -> void:
	color_rect.size = rectangle.size


func scale(direction:String, amount:int):
	match direction:
		"left":
			rectangle.position.x -= amount
		"right":
			rectangle.size.y += amount
		"up":
			rectangle.position.x -= amount
		"down":
			rectangle.size.y += amount
