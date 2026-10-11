@tool
class_name Level extends Node2D

@export var playerStartCoord:Vector2i

func get_board_tilemap() -> TileMapLayer:
	return get_node("Board")

func get_goals_tilemap() -> TileMapLayer:
	return get_node("Goals")

func get_boxes() -> Array[SokoBox]:
	var boxes:Array[SokoBox] = []
	for box in get_node("Boxes").get_children():
		if box is SokoBox:
			boxes.append(box)
	return boxes
	
