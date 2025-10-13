extends CanvasLayer

@export var max_hearts : int = 3
var current_hearts: int

var player_coin_count: int = 0
var pong_coin_count: int = 0

@onready var heart_container = $HealthContainer

@onready var coin_container = $CoinContainer
@onready var coin_count_display = $CoinContainer/CoinCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hearts = max_hearts
	update_hearts()
	
	var borders_node = get_tree().root.get_node("Game/Borders")
	for border in borders_node.get_children():
		if border.has_signal("took_damage"):
			border.connect("took_damage", Callable(self, "remove_heart"))
	
	# Align with view
	$HealthContainer.position = Vector2(10, 10)
	
	display_coins()


func remove_heart():
	print("remove_heart triggered")
	if current_hearts > 0:
		current_hearts -= 1
		update_hearts()
	
func update_hearts():
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		var heart_empty = heart.get_node("HealthEmpty")
		var heart_full = heart.get_node("Health")
		
		heart_empty.visible = i >= current_hearts
		heart_full.visible = i < current_hearts
	
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
	print("Player coins:", player_coin_count)
	print("Pong coins:", pong_coin_count)
	coin_count_display.text = str(player_coin_count)
	pass
