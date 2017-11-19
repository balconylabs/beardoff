extends Node2D

var head
var beard

#number of ticks before the face sprite freezes animation
var numTicksAnimSwitch = 12

#number of ticks before the long beard sprite is displayed
var beardVisibleTicks = 11

#initial position of long beard sprite
var initBeardPosX = 0
var initBeardPosY = -53

func _ready():
	head = get_node("headSprite")
	beard = get_node("longbeard")
	
	head.set_frame(0)
	beard.set_position(Vector2(initBeardPosX, initBeardPosY))
	beard.hide()

func tick(var currentTick):
	if(currentTick < numTicksAnimSwitch):
		head.set_frame(head.get_frame() + 1)
	else:
		var pos = beard.get_position()
		beard.set_position(Vector2(pos.x, pos.y + 1))
	
	if(currentTick == beardVisibleTicks):
		beard.show()
		
		
func shave():
	head.set_frame(0)
	beard.set_position(Vector2(initBeardPosX, initBeardPosY))
	beard.hide()
	
func isTooLong():
	return beard.position.y >= 0
