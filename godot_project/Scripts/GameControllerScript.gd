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
var gameOverNode
var beardStatusNode

#scene variables
var gameOverScene
var beardStatusScene

#scale factor to fill screen with beard display
var beardDisplayPixelScale = 7.5
var beardScale

 
var gameRunning = false




func _ready():
	
	gameOverScene = load("res://Scenes/GameOverScene.tscn")
	gameOverNode = gameOverScene.instance()
	
	beardStatusScene = load("res://Scenes/BeardStatusScene.tscn")
	beardStatusNode = beardStatusScene.instance()
	add_child(beardStatusNode)
	beardScale = Vector2(beardDisplayPixelScale,beardDisplayPixelScale)
	beardStatusNode.set_scale(beardScale)
	
	gameRunning = true
	set_process(true)

func _process(delta):
	elapsedTime += delta
	
	if(gameRunning):
		if(elapsedTime - lastTickTime >= secondsPerTick):
			
			#do tick
			beardStatusNode.tick(currentTick)
			
			#if OS.is_debug_build():
			#	print("tick: ", currentTick)
						
			
			
			currentTick += 1
			lastTickTime = elapsedTime
			
		if(beardStatusNode.isTooLong()):
			lose()


func _on_Button_pressed():
	
	#shave
	beardStatusNode.shave()
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
	remove_child(beardStatusNode)
	beardStatusNode = beardStatusScene.instance()
	add_child(beardStatusNode)
	beardStatusNode.set_scale(beardScale)

	#reset the game board
	
	remove_child(gameOverNode)
	
	#start game
	gameRunning = true

