extends Area2D

@export var SPEED := 350.0
@export var START_MAX_ANGLE := 22.5 # Max randomized starting angle. 1 is vertical 0 is horizontal
@export var BOUNCE_ANGLE_REDUCTION := 0.5
@export var BOUNCE_MARGIN = 50

var velocity := Vector2.ZERO

signal hit_player
signal pong_died

@onready var first_paddle = get_tree().get_first_node_in_group("paddles")
@onready var paddle_sprite = first_paddle.get_node("Sprite2D")
@onready var paddle_height = paddle_sprite.texture.get_height() * paddle_sprite.scale.y

@onready var game = get_tree().root.get_node("Game")

var camera
var zoom
var screen_size
var top_left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	zoom = camera.zoom
	screen_size = get_viewport_rect().size / zoom
	top_left = camera.get_screen_center_position() - (screen_size / 2)
	
	# Set the ball to starting position
	position.x = -350
	position.y = 0

	# Starting velocity
	var direction = Vector2(1, randf_range(0 - (START_MAX_ANGLE / 90), (START_MAX_ANGLE / 90))).normalized()
	velocity = direction * SPEED
	print(velocity)
	
	# Test tone sweep
	#play_beep("sweep")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	# Bounce off top/bottom
	if global_position.y <= top_left.y:
		velocity.y = abs(velocity.y)
		game.play_sound("wall")
	if global_position.y >= (top_left.y + screen_size.y):
		velocity.y = -abs(velocity.y)
		game.play_sound("wall")
	
	# Die when hitting sides
	if global_position.x <= top_left.x - BOUNCE_MARGIN or global_position.x >= (top_left.x + screen_size.x + BOUNCE_MARGIN):
		emit_signal("pong_died")
		queue_free()
		#game.play_sound("wall")

func _on_body_entered(body: Node2D) -> void:
	# Player
	if body.name == "Player":
		game.play_sound("hit_player")
		emit_signal("hit_player")


func _on_area_entered(area: Area2D) -> void:
	# Paddles
	if area.is_in_group("paddles"):
		velocity.x = -velocity.x
		game.play_sound("paddle")
		
		var ball_paddle_dist_y = global_position.y - area.global_position.y
		var paddle_radius = 52.5
		#var normalized = clamp(ball_paddle_dist_y / paddle_radius, -1, 1)
		var theta = asin(clamp(ball_paddle_dist_y / paddle_radius, -1, 1))
		var reduced_angle = theta * BOUNCE_ANGLE_REDUCTION
		var _bounce_angle = theta * 2
		
		var normal
		# Left paddle
		if global_position.x < (screen_size.x / 2):
			normal = Vector2(-1, sin(reduced_angle)).normalized() # Line across which the ball's trajectory will be mirrorerd
		# Right paddle
		else:
			normal = Vector2(1, sin(reduced_angle)).normalized()
		
		velocity = velocity.bounce(normal).normalized() * SPEED
		
		velocity.x = -velocity.x
		
		position.x += sign(velocity.x) * 20
		
	
	if area.is_in_group("coins"):
		# game.play_sound("coin")
		print("coin")
