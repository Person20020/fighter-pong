extends Area2D

const PLAYER_LAYER = 2
const BALL_LAYER = 3
const COIN_SPAWN_DELAY = 5 # Time between coins spawning (in seconds)

@onready var coinSpawnPoints = get_tree().root.get_node("Game/CoinSpawnPoints")

@onready var last_coin_spawn = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get a list of the coin spawn points
	var coinSpawnPointsPos = []
	
	for coinSpawnPoint in coinSpawnPoints:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	if ((now - last_coin_spawn) / 1000) < COIN_SPAWN_DELAY:
		spawn_coin()
		last_coin_spawn = Time.get_ticks_msec()


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
			
		elif BALL_LAYER in collided_object_layers:
			print("Ball collided with coin")
	
		queue_free()


func spawn_coin() -> void:
	# Choose a random spawn point
	pass
	
