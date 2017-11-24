extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#ref to GameControllerNode
onready var gc = get_node("/root/gameController")

#neighbors
var U = null
var D = null
var L = null
var R = null

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
			if(OS.is_debug_build()): print(wireTile)
			wireTile.set_position(position)
			isEmpty = false

