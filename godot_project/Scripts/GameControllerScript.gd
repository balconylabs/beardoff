extends Node2D

#total time elapsed this game
var elapsedTime = 0

#time the last tick occurred
var lastTickTime = 0

#total ticks elapsed this game
var currentTick = 0

#how long a tick takes
var secondsPerTick = .5

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

#Game Board 2D Array
var gameboard

var boardSpaceScene

const GB_ROWS = 7
const GB_COLS = 10
const GB_X_OFFSET = 383
const GB_Y_OFFSET = 0
const TILE_WIDTH = 64
const TILE_HEIGHT = 64
const TILE_X_OFFSET = 32
const TILE_Y_OFFSET = 32

var tileQueue
const QUEUE_LENGTH = 5
const QUEUE_X_OFFSET = 300
const QUEUE_Y_OFFSET = 0

#define the different ways tiles can connect
enum ConnectionType {
	LEFT_AND_RIGHT,
	UP_AND_DOWN,
	UP_AND_DOWN_AND_L_AND_R,
	LEFT_AND_DOWN,
	UP_AND_LEFT,
	RIGHT_AND_UP,
	DOWN_AND_RIGHT
}







func _ready():
	
	
	gameOverScene = load("res://Scenes/GameOverScene.tscn")
	gameOverNode = gameOverScene.instance()
	
	beardStatusScene = load("res://Scenes/BeardStatusScene.tscn")
	beardStatusNode = beardStatusScene.instance()
	add_child(beardStatusNode,true)
	beardScale = Vector2(beardDisplayPixelScale,beardDisplayPixelScale)
	beardStatusNode.set_scale(beardScale)
	
	#initialize game board
	initGameBoard()

			
			
			
	#init tile queue
	initTileQueue()
			
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

func initTileQueue():
	
	#clear any previous tiles
	for i in get_node("WireTilesNode").get_children():
		i.queue_free()
	
	tileQueue = []
	for i in range(QUEUE_LENGTH):
		#tileQueue.push_back(boardSpaceScene.instance())
		tileQueue.push_back(randomWireTile())
		get_node("WireTilesNode").add_child(tileQueue[i],true)
		tileQueue[i].set_position(Vector2(TILE_X_OFFSET + QUEUE_X_OFFSET, i * TILE_HEIGHT + TILE_Y_OFFSET + QUEUE_Y_OFFSET))
		
	if(OS.is_debug_build()): print("init queue: ",tileQueue)
		
func initGameBoard():
	
	#clear out previous board
	for i in get_node("GameBoardNode").get_children():
		i.queue_free()
	
	boardSpaceScene = preload("res://Scenes/BoardSpace.tscn")
	
	gameboard = []
	
	for i in range(GB_COLS):
#		if(OS.is_debug_build()): print("i=",i)
		gameboard.append([])
		for j in range(GB_ROWS):
			gameboard[i].append(boardSpaceScene.instance())
			#gameboard[i][j]=boardSpaceScene.instance()
#			if(OS.is_debug_build()): print(gameboard[i][j])
				
			gameboard[i][j].set_position(Vector2(i * TILE_WIDTH + TILE_X_OFFSET + GB_X_OFFSET, j * TILE_HEIGHT + TILE_Y_OFFSET + GB_Y_OFFSET))
			get_node("GameBoardNode").add_child(gameboard[i][j],true)
			
	#set gameboard neighbors
	for i in range(GB_COLS):
		for j in range(GB_ROWS):
				#set neighbors
			if(i > 0):
				gameboard[i][j].L = gameboard[i-1][j]
			if(i < GB_COLS - 1):
				gameboard[i][j].R = gameboard[i+1][j]
			if(j > 0):
				gameboard[i][j].U = gameboard[i][j-1]
			if(j < GB_ROWS - 1):
				gameboard[i][j].D = gameboard[i][j+1]
				
			#print the neigbors
#			print("U ",gameboard[i][j].U)
#			print("D ",gameboard[i][j].D)
#			print("L ",gameboard[i][j].L)
#			print("R ",gameboard[i][j].R)


func _on_Button_pressed():
	
	#shave
	beardStatusNode.shave()
	currentTick = 0
	
func lose():
	
	
	
	#pause everything
	gameRunning = false
	
	#display "game over"
	#show restart option

	for i in get_node("GameOverScreen").get_children():
		i.queue_free()

	var pos = Vector2(24 * 7.5, 0);
	gameOverNode.set_position(pos)
	get_node("GameOverScreen").add_child(gameOverNode,true)
	
	
func restart():
	#restart the game
	
	initGameBoard()
	initTileQueue()
	
	#reset game variables
	elapsedTime = 0
	lastTickTime = 0
	currentTick = 0
	
	#reset beard display
	beardStatusNode.queue_free()
	beardStatusNode = beardStatusScene.instance()
	add_child(beardStatusNode,true)
	beardStatusNode.set_scale(beardScale)

	#reset the game board
	
	get_node("GameOverScreen").remove_child(gameOverNode)
	
	#start game
	gameRunning = true

func randomWireTile():
	var wireTileNode = preload("res://Scenes/WireTile.tscn").instance()
	
	#get random index that will be used to get the frame of the sprite that corresponds to the ConnectionType enum value
	var tileType = randi() % ConnectionType.size()
	
	wireTileNode.connectionType = tileType
	wireTileNode.get_node("Area2D/wire_tile_sprite").frame = tileType
	
	return wireTileNode
	
#returns the next tile in the queue, pops it from the queue, adds next tile
func grabNextTile():
	var tileToReturn = tileQueue.pop_back()
#	if(OS.is_debug_build()): print(tileToReturn)
	
	
	enqueueNewTile()
	
	
	return tileToReturn

func enqueueNewTile():
		#reposition all the tiles in the queue down by 1 tile
	for tile in tileQueue:
		tile.set_position(tile.position + Vector2(0,TILE_HEIGHT))

	var newTile = randomWireTile()
	newTile.set_position(Vector2(TILE_X_OFFSET + QUEUE_X_OFFSET, TILE_Y_OFFSET + QUEUE_Y_OFFSET))
	tileQueue.push_front(newTile)		
	
	get_node("WireTilesNode").add_child(newTile)