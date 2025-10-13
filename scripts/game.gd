extends Node2D

const COIN_SPAWN_DELAY:int = 3 # Time between coins spawning (in seconds)
const MAX_SPAWNED_COINS:int = 5
const REQUIRE_UNIQUE_COIN_POS:bool = true


@onready var coin_spawn_points = get_tree().root.get_node("Game/CoinSpawnPoints").get_children()
@onready var last_coin_spawn = Time.get_ticks_msec()

var coin_spawn_points_pos = []
var next_coin_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for coin_spawn_point in coin_spawn_points:
		coin_spawn_points_pos.append(coin_spawn_point.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var now:float = Time.get_ticks_msec()
	if ((now - last_coin_spawn) / 1000.0) >= COIN_SPAWN_DELAY:
		spawn_coin()
		last_coin_spawn = now

func spawn_coin() -> void:
	var coin_node = get_tree().root.get_node("Game/Coins")
	
	# Choose a random spawn point
	var spawn_point_count = len(coin_spawn_points_pos)
	var rand:int = randi_range(0, (spawn_point_count - 1))
	
	var new_spawn_pos = coin_spawn_points_pos[rand]
	
	# Check for max coin count
	var existing_coins_pos = []
	for coin in coin_node.get_children():
		existing_coins_pos.append(coin.global_position)
	
	
	if len(existing_coins_pos) >= MAX_SPAWNED_COINS:
		return
		
	# Check if there is already a coin there if REQUIRE_UNIQUE_COIN_POS is enabled
	if REQUIRE_UNIQUE_COIN_POS:
		for coin_pos in existing_coins_pos:
			if coin_pos == new_spawn_pos:
				spawn_coin()
				return
		 
	var coin_scene = load("res://scenes/coin.tscn")
	var coin_instance = coin_scene.instantiate()
	
	coin_node.add_child(coin_instance)
	coin_instance.add_to_group("coins")
	
	coin_instance.position = Vector2(coin_spawn_points_pos[rand])
	coin_instance.name = "Coin%d" % next_coin_id
	
	next_coin_id += 1
	
	# Connect signals from the coin to a function in the overlay
	var overlay = get_tree().root.get_node("Game/Overlay")
	coin_instance.connect("player_collect_coin", overlay.add_coin)


func play_sound(type: String) -> void:
	pass
