extends CanvasLayer

@export var max_hearts: int = 3
@export var PLAYER_ABILITY_COST: int = 15
@export var PONG_ABILITY_COST: int = 10

var player_current_hearts: int

var pong_current_hearts: int

var player_coin_count: int = 0
var pong_coin_count: int = 0

@onready var heart_container = $HealthContainer
@onready var pong_heart_container = $PongContainer/HealthContainer

@onready var ball = get_tree().root.get_node("Game/Ball")

@onready var coin_container = $CoinContainer
@onready var player_coin_count_display = $CoinContainer/CoinCount
@onready var pong_coin_count_display = $PongContainer/CoinContainer/CoinCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_current_hearts = max_hearts
	pong_current_hearts = max_hearts
	update_hearts()
	
	var borders_node = get_tree().root.get_node("Game/Borders")
	for border in borders_node.get_children():
		if border.has_signal("took_damage"):
			border.connect("took_damage", Callable(self, "remove_heart"))
	
	# Align with view
	$HealthContainer.position = Vector2(10, 10)
	
	ball.connect("hit_player", Callable(self, "remove_heart"))
	ball.connect("pong_died", Callable(self, "remove_heart").bind(false))
	
	display_coins()


func remove_heart(player: bool = true, spawn_ball: bool = true):
	if player:
		if player_current_hearts > 0:
			player_current_hearts -= 1
		print("player heart triggered")
	else:
		if pong_current_hearts > 0:
			pong_current_hearts -= 1
			if spawn_ball:
				# Create new ball. Old one is destroyed
				var new_ball = load("res://scenes/ball.tscn")
				var new_ball_instance = new_ball.instantiate()
				get_tree().root.get_node("Game").add_child(new_ball_instance)
				new_ball_instance.connect("pong_died", Callable(self, "remove_heart").bind(false))
				new_ball_instance.connect("hit_player", Callable(self, "remove_heart"))
		print("pong heart removed")
	update_hearts()
	
func update_hearts():
	# Player
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		var heart_empty = heart.get_node("HealthEmpty")
		var heart_full = heart.get_node("Health")
		
		heart_empty.visible = i >= player_current_hearts
		heart_full.visible = i < player_current_hearts
		
	# Pong
	for i in range(pong_heart_container.get_child_count()):
		var heart = pong_heart_container.get_child(i)
		var heart_empty = heart.get_node("HealthEmpty")
		var heart_full = heart.get_node("Health")
		
		heart_empty.visible = i >= pong_current_hearts
		heart_full.visible = i < pong_current_hearts
		
	if player_current_hearts <= 0 or pong_current_hearts <= 0:
		if get_tree():
			get_tree().reload_current_scene()
	
func add_coin(count: int = 1, player: bool = true):
	if player:
		player_coin_count += count
	else:
		pong_coin_count += count
	display_coins()
	
func remove_coin(count: int, player: bool = true):
	if player:
		player_coin_count -= count
	else:
		pong_coin_count -= count
	display_coins()
	
func display_coins():
	# print("Player coins:", player_coin_count)
	# print("Pong coins:", pong_coin_count)
	player_coin_count_display.text = str(player_coin_count)
	pong_coin_count_display.text = str(pong_coin_count)
	
	if player_coin_count >= PLAYER_ABILITY_COST:
		# display "Press 'E' to activate ability"
		$PlayerActivateAbility.visible = true
	else:
		$PlayerActivateAbility.visible = false
	
	
	if pong_coin_count >= PONG_ABILITY_COST:
		# display "Use Right Click to activate ability"
		$PongContainer/PongActivateAbility.visible = true
	else:
		$PongContainer/PongActivateAbility.visible = false
		
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("player_ability"):
		if player_coin_count >= PLAYER_ABILITY_COST:
			remove_coin(PLAYER_ABILITY_COST)
			remove_heart(false, false)
			print("removed pong heart")
	
	if Input.is_action_just_pressed("pong_ability"):
		if pong_coin_count >= PONG_ABILITY_COST:
			remove_coin(PONG_ABILITY_COST, false)
			remove_heart(true)
			print("removed player heart")
