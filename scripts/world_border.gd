extends Area2D

const PLAYER_LAYER = 2
signal took_damage

var lost:bool = false

@onready var timer = $Timer
@onready var overlay = get_tree().root.get_node("Game/Overlay")
@onready var player = get_tree().root.get_node("Game/Player")
@onready var spawn_point = get_tree().root.get_node("Game/SpawnPoint")


func _on_body_entered(body: Node2D) -> void:
	# Get body layers
	var collided_object_bitmask = body.collision_layer
	var collided_object_layers = []
	
	for i in range(1, 33):
		if collided_object_bitmask & (1 << (i - 1)):
			print(" - On layer", i)
			collided_object_layers.append(i)
	
	# Reduce lives by 1
	if PLAYER_LAYER in collided_object_layers:
		print("took_damage")
		emit_signal("took_damage")
		
		if overlay.player_current_hearts <= 0:
			lost = true
			timer.start(3)
			return
		
		timer.start(.35)


func _on_timer_timeout() -> void:
	# Check timer reason
	# Player lost all lives
	if lost:
		# play the end scene
		get_tree().reload_current_scene()
	# Player lost a single life but hasn't fully lost yet
	else:
		player.global_position = spawn_point.global_position
		player.velocity = Vector2.ZERO
		timer.stop()
