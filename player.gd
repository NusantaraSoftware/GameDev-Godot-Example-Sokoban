@tool
class_name Player extends AnimatedSprite2D

@export var coord: Vector2i:
	set(i): coord = i; set_coord(coord)
@export var direction: Vector2i:
	set(d): set_direction(d, is_moving)
	get(): return _direction
var _direction:Vector2i
@export var is_moving: bool:
	set(m): set_direction(_direction, m)
	get(): return _is_moving
var _is_moving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_direction(Vector2i(0, 1), false)
	play("down")
	pass # Replace with function body.

func set_coord(c: Vector2i):
	position = c * 128.0

func set_direction(d:Vector2i, walk:bool = false):
	_direction = Vector2i(Vector2(d).normalized())
	_is_moving = walk
	var move:String = ""
	match _direction:
		Vector2i(0,1):
			move = "down"
		Vector2i(0,-1):
			move = "up"
		Vector2i(1,0):
			move = "right"
		Vector2i(-1,0):
			move = "left"
	if move == "":
		pass
	if walk:
		move += "-walk"
	play(move)
