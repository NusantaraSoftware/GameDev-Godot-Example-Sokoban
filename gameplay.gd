@tool
class_name Gameplay extends Node2D
@onready var player:Player = $Player
@export var levelNumber:int:
	set(l): levelNumber = l; get_ready()
var player_movement_delta:float
var level:Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_ready()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_moving:
		var current_position = player.coord * 128.0
		var target_coord = player.coord + player.direction
		var target_position = target_coord * 128.0
		player_movement_delta += delta * 2
		player.position = current_position.lerp(target_position, player_movement_delta)
		var box:SokoBox = get_box_at_coord(target_coord)
		if box != null:
			box.position = target_position.lerp((target_coord + player.direction) * 128.0, player_movement_delta)
		if player_movement_delta >= 1:
			player.coord = target_coord
			player.set_direction(player.direction, false)
			if box != null:
				box.coord = target_coord + player.direction
				if check_win_condition():
					try_start_level(levelNumber + 1)
	elif not Engine.is_editor_hint():
		if Input.is_action_pressed("ui_accept"):
			try_start_level(levelNumber)
		if Input.is_action_pressed("ui_down"):
			try_move_player(0,1)
		if Input.is_action_pressed("ui_up"):
			try_move_player(0,-1)
		if Input.is_action_pressed("ui_left"):
			try_move_player(-1,0)
		if Input.is_action_pressed("ui_right"):
			try_move_player(1,0)
	pass

func get_ready():
	if levelNumber < 1:
		levelNumber = 1
	if is_node_ready():
		var levelName = "%02d" % [levelNumber]
		for l in get_node("Levels").get_children():
			l.visible = l.name == levelName
		level = get_node("Levels/" + levelName)
		player.coord = level.playerStartCoord
		player.set_direction(Vector2i(0,1), false)
		$Label_Sokoban.text = "Level %s" % [levelName]
	pass

func try_move_player(dirx:int, diry:int) -> bool:
	var direction:Vector2i = Vector2i(dirx, diry)
	player.set_direction(direction, false)
	match check_what_at_coord(player.coord + direction):
		"wall":
			return false
		"box":
			if check_what_at_coord(player.coord + direction + direction) != "":
				return false
	player.set_direction(direction, true)
	player_movement_delta = 0
	return false

func check_what_at_coord(coord:Vector2i) -> String:
	var tile = level.get_board_tilemap().get_cell_atlas_coords(coord)
	if tile.y == 7:
		return "wall"
	if get_box_at_coord(coord) != null:
		return "box"
	return ""

func get_box_at_coord(coord:Vector2i) -> SokoBox:
	for box in level.get_boxes():
		if box.coord == coord:
			return box
	return null

func check_win_condition() -> bool:
	for box in level.get_boxes():
		if level.get_goals_tilemap().get_cell_atlas_coords(box.coord) == Vector2i(-1, -1):
			return false
	return true

func try_start_level(num:int):
	if get_node("Levels/%02d" % [num]) == null:
		num = 1
	var new_scene = preload("res://gameplay.tscn").instantiate()
	new_scene.levelNumber = num
	$SceneTransitionRect.transition_to(get_tree(), new_scene)
	pass
