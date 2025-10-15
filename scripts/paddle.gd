extends Area2D

@export var MOVEMENT_INCREMENT = 20 # In px

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Scroll based control
	"""
	if Input.is_action_just_pressed("pong_up"):
		if position.y < (get_viewport_rect().size.y / 2):
			position.y += MOVEMENT_INCREMENT
	
	if Input.is_action_just_pressed("pong_down"):
		if position.y > -(get_viewport_rect().size.y / 2):
			position.y -= MOVEMENT_INCREMENT
	"""
	
	# Paddle follows mouse
	"""
	var camera = get_viewport().get_camera_2d()
	var zoom = camera.zoom.x
	var mouse_y = get_viewport().get_mouse_position().y
	global_position.y = mouse_y / zoom
	"""
	global_position.y = get_global_mouse_position().y
