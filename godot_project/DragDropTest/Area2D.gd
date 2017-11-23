extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var isDragging = false
var isClickable = true
var overValidTarget = false

var mouse_tile_pos_offset

var original_position

var tile_node
var tile_size

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	tile_node = get_node("icon")
	tile_size = tile_node.get_texture().get_size()
	
	set_process(true)

func _process(delta):
	if(isDragging):
		self.position = get_global_mouse_position() + mouse_tile_pos_offset
	

func _input_event(viewport, event, shape_idx):
	if(event is InputEventMouseButton and event.button_index == BUTTON_LEFT and isClickable):
		if(event.pressed):
			print("Clicked")
			isDragging = true
			#store original position
			original_position=position
			#save mouse offset
			print(self.position)
			print(get_global_mouse_position())
			mouse_tile_pos_offset = self.position - get_global_mouse_position()
		else:
			print("Released")
			print("overValidTarget: ",overValidTarget)
			if(overValidTarget):
				position.x = clamp(position.x, tile_size.x/2, get_viewport_rect().size.x - tile_size.x / 2)
				position.y = clamp(position.y, tile_size.y/2, get_viewport_rect().size.y - tile_size.y / 2)
			else:
				position = original_position
			isDragging = false
						
			


func _on_tile_area_entered( area ):
	print("area entered - name:",area.get_name())
	print("group(s) of entered area: ", area.get_groups())
	if(area.is_in_group("validtarget")):
		#add tile to target
		overValidTarget = true
		pass
	
	
	
	

func _on_tile_area_exited( area ):
	print("area exited - name:",area.get_name())
	print("group(s) of exited area: ", area.get_groups())
	if(area.is_in_group("validtarget")):
		#add tile to target
		overValidTarget = false
	pass # replace with function body
