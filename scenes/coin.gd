extends Area2D

const PLAYER_LAYER = 2
const BALL_LAYER = 3

signal player_collect_coin
signal ball_collect_coin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get a list of the coin spawn points
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is PhysicsBody2D:
		var collided_object_bitmask = body.collision_layer
		var collided_object_layers = []
		
		for i in range(1, 33):
			if collided_object_bitmask & (1 << (i - 1)):
				print(" - On layer", i)
				collided_object_layers.append(i)
		 
		if PLAYER_LAYER in collided_object_layers:
			print("Player collided with coin")
			emit_signal("player_collect_coin")
			
			
		elif BALL_LAYER in collided_object_layers:
			print("Ball collided with coin")
			emit_signal("ball_collect_coin")
	
		queue_free()
