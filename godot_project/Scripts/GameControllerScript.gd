extends Node2D
var elapsedTime = 0
var lastTickTime = 0

var currentTick = 0
var animTick = .1
var numTicksAnimSwitch = 12
var beardVisibleTicks = 11
var pixelScale = 7.5

var gameRunning = true

var head
var beard



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	head = get_node("headSprite")
	beard = get_node("longbeard")
	
	set_process(true)

func _process(delta):
	elapsedTime += delta
	
	if((elapsedTime - lastTickTime >= animTick) and gameRunning):
		#do tick
		#print("tick: ")
		
		if(currentTick < numTicksAnimSwitch):
			head.set_frame(head.get_frame() + 1)
		else:
			var pos = beard.get_position()
			beard.set_position(Vector2(pos.x, pos.y + 1 * pixelScale))
		
		if(currentTick == beardVisibleTicks):
			beard.show()
		
		currentTick += 1
		lastTickTime = elapsedTime
		
	if (beard.position.y >= 0):
		lose()
		
func _on_Button_pressed():
	#shave
	head.set_frame(0)
	beard.set_position(Vector2(0, -404))
	beard.hide()
	currentTick = 0
	
func lose():
	
	#pause everything
	gameRunning = false
	
	#display "game over"
	#show restart option
	var gameOverScene = load("res://Scenes/GameOverScene.tscn")
	var gameOverNode = gameOverScene.instance()
	var pos = Vector2(24 * 7.5, 0);
	gameOverNode.set_position(pos)
	add_child(gameOverNode)
	
func restart():
	head.hide()
	pass




