extends Node2D

#total time elapsed this game
var elapsedTime = 0

#time the last tick occurred
var lastTickTime = 0

#total ticks elapsed this game
var currentTick = 0

#how long a tick takes
var secondsPerTick = .1



#node variables
var head
var beard
var gameOverNode

#scene variables
var gameOverScene

#number of ticks before the face sprite freezes animation
var numTicksAnimSwitch = 12

#number of ticks before the long beard sprite is displayed
var beardVisibleTicks = 11

#scale factor to fill screen with beard display
var beardDisplayPixelScale = 7.5

#initial position of long beard sprite
var initBeardPosX = 0
var initBeardPosY = -404
 
var gameRunning = false




func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	head = get_node("headSprite")
	beard = get_node("longbeard")
	
	gameOverScene = load("res://Scenes/GameOverScene.tscn")
	gameOverNode = gameOverScene.instance()
	
	gameRunning = true
	set_process(true)

func _process(delta):
	elapsedTime += delta
	
	if(gameRunning):
		if(elapsedTime - lastTickTime >= secondsPerTick):
			
			#do tick
			
			#if OS.is_debug_build():
			#	print("tick: ", currentTick)
						
			if(currentTick < numTicksAnimSwitch):
				head.set_frame(head.get_frame() + 1)
			else:
				var pos = beard.get_position()
				beard.set_position(Vector2(pos.x, pos.y + 1 * beardDisplayPixelScale))
			
			if(currentTick == beardVisibleTicks):
				beard.show()
			
			currentTick += 1
			lastTickTime = elapsedTime
			
		if (beard.position.y >= 0):
			lose()


func _on_Button_pressed():
	
	#shave
	head.set_frame(0)
	beard.set_position(Vector2(initBeardPosX, initBeardPosY))
	beard.hide()
	currentTick = 0
	
func lose():
	
	#pause everything
	gameRunning = false
	
	#display "game over"
	#show restart option

	var pos = Vector2(24 * 7.5, 0);
	gameOverNode.set_position(pos)
	add_child(gameOverNode)
	
func restart():
	#restart the game
	
	#reset game variables
	elapsedTime = 0
	lastTickTime = 0
	currentTick = 0
	
	#reset beard display
	head.set_frame(0)
	beard.set_position(Vector2(initBeardPosX, initBeardPosY))
	beard.hide()

	#reset the game board
	
	remove_child(gameOverNode)
	
	#start game
	gameRunning = true

