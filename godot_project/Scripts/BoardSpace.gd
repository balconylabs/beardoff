extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#ref to GameControllerNode
onready var gc = get_node("/root/gameController")

enum ConnectionType {
	LEFT_AND_RIGHT,
	UP_AND_DOWN,
	UP_AND_DOWN_AND_LEFT_AND_RIGHT,
	LEFT_AND_DOWN,
	UP_AND_LEFT,
	RIGHT_AND_UP,
	DOWN_AND_RIGHT
}

#neighbors
var UP = null
var DOWN = null
var LEFT = null
var RIGHT = null

#is there a tile on this space?
var isEmpty = true

var isPlug = false
var isRazor = false

#will point the the tile that is placed on this space
var wireTile = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_mouse_entered():
	get_node("Area2D/empty_tile_64x64").frame = 1
	pass # replace with function body
	
	


func _on_Area2D_mouse_exited():
	get_node("Area2D/empty_tile_64x64").frame = 0
	pass # replace with function body


func _on_Area2D_input_event( viewport, event, shape_idx ):
	if(event is InputEventMouseButton && event.pressed):
		if(event.button_index == BUTTON_LEFT && isEmpty):
			wireTile = gc.grabNextTile()
#			if(OS.is_debug_build()): print(wireTile)
			wireTile.set_position(position)
			isEmpty = false
			gc.doCheck()

func isConnectedTo(direction):
	if(isPlug):
		if(direction == "DOWN"):
			if(DOWN.wireTile != null):
				if(DOWN.wireTile.connectionType == ConnectionType.UP_AND_DOWN || 
				DOWN.wireTile.connectionType == ConnectionType.UP_AND_LEFT || 
				DOWN.wireTile.connectionType == ConnectionType.RIGHT_AND_UP || 
				DOWN.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT):
					return true
			
		if(direction == "RIGHT"):
			if(RIGHT.wireTile != null):
				if(RIGHT.wireTile.connectionType == ConnectionType.LEFT_AND_DOWN || 
				RIGHT.wireTile.connectionType == ConnectionType.UP_AND_LEFT || 
				RIGHT.wireTile.connectionType == ConnectionType.LEFT_AND_RIGHT || 
				RIGHT.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT):
					return true
	else:
		if(direction == "UP"):
			if(UP && UP.wireTile != null):
				if(
				(wireTile.connectionType == ConnectionType.UP_AND_DOWN || 
				wireTile.connectionType == ConnectionType.UP_AND_LEFT || 
				wireTile.connectionType == ConnectionType.RIGHT_AND_UP || 
				wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT) 
				&& 
				(UP.wireTile.connectionType == ConnectionType.DOWN_AND_RIGHT || 
				UP.wireTile.connectionType == ConnectionType.UP_AND_DOWN || 
				UP.wireTile.connectionType == ConnectionType.LEFT_AND_DOWN ||
				UP.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT)):
					return true
				
				 
		if(direction == "DOWN"):
			if(DOWN && DOWN.wireTile != null):
				if(
				(wireTile.connectionType == ConnectionType.DOWN_AND_RIGHT || 
				wireTile.connectionType == ConnectionType.UP_AND_DOWN || 
				wireTile.connectionType == ConnectionType.LEFT_AND_DOWN ||
				wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT) 
				&& 
				(DOWN.wireTile.connectionType == ConnectionType.UP_AND_DOWN || 
				DOWN.wireTile.connectionType == ConnectionType.UP_AND_LEFT || 
				DOWN.wireTile.connectionType == ConnectionType.RIGHT_AND_UP || 
				DOWN.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT)):
					return true
			
		if(direction == "RIGHT"):
			if(RIGHT && RIGHT.wireTile != null):
				if(
				(wireTile.connectionType == ConnectionType.RIGHT_AND_UP || 
				wireTile.connectionType == ConnectionType.DOWN_AND_RIGHT || 
				wireTile.connectionType == ConnectionType.LEFT_AND_RIGHT ||
				wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT) 
				&& 
				(RIGHT.wireTile.connectionType == ConnectionType.LEFT_AND_DOWN || 
				RIGHT.wireTile.connectionType == ConnectionType.UP_AND_LEFT || 
				RIGHT.wireTile.connectionType == ConnectionType.LEFT_AND_RIGHT || 
				RIGHT.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT)):
					return true
		if(direction == "LEFT"):
			if(LEFT && LEFT.wireTile != null):
				if(
				(wireTile.connectionType == ConnectionType.LEFT_AND_DOWN || 
				wireTile.connectionType == ConnectionType.LEFT_AND_RIGHT || 
				wireTile.connectionType == ConnectionType.UP_AND_LEFT ||
				wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT) 
				&& 
				(LEFT.wireTile.connectionType == ConnectionType.RIGHT_AND_UP || 
				LEFT.wireTile.connectionType == ConnectionType.DOWN_AND_RIGHT || 
				LEFT.wireTile.connectionType == ConnectionType.LEFT_AND_RIGHT || 
				LEFT.wireTile.connectionType == ConnectionType.UP_AND_DOWN_AND_LEFT_AND_RIGHT)):
					return true
	
	return false