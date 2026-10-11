@tool
class_name SokoBox extends Sprite2D

@export var coord: Vector2i:
	set(i): coord = i; set_coord(coord)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_coord(c: Vector2i):
	position = c * 128.0
