extends Area2D

@export var SPEED := 350.0
@export var START_MAX_ANGLE := 22.5 # Max randomized starting angle. 1 is vertical 0 is horizontal

var velocity := Vector2.ZERO

signal ball_collect_coin

@onready var beep_player = $BeepPlayer
@onready var paddle_sprite = get_tree().get_first_node_in_group("paddles").get_node("Sprite2D")
@onready var paddle_height = paddle_sprite.texture.get_height() * paddle_sprite.scale.y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Starting velocity
	var direction = Vector2(1, randf_range(0 - (START_MAX_ANGLE / 90), (START_MAX_ANGLE / 90))).normalized()
	velocity = direction * SPEED
	print(velocity)
	
	# Test tone sweep
	#play_beep("sweep")
	print(paddle_height)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if position.y < (0 - (get_viewport_rect().size.y / 2)) or position.y > (get_viewport_rect().size.y / 2):
		velocity.y = -velocity.y
		play_beep("wall")
	if position.x < (0 - (get_viewport_rect().size.x / 2)) or position.x > (get_viewport_rect().size.x / 2):
		velocity.x = -velocity.x
		play_beep("wall")
	
	#print(position)


func _on_body_entered(body: Node2D) -> void:
	# Player
	if body.name == "Player":
		play_beep("hit_player")


func _on_area_entered(area: Area2D) -> void:
	# Paddles
	if area.is_in_group("paddles"):
		velocity.x = -velocity.x
		play_beep("paddle")
	
	if area.is_in_group("coins"):
		play_beep("coin")
		print("coin")
		emit_signal("ball_collect_coin")


func play_beep(type: String = "wall") -> void :
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100
	beep_player.stream = generator
	beep_player.play()
	
	var tones = {"c": 261.63, "d": 293.66, "e": 329.63, "f": 349.23, "g": 392.0, "a": 440.0, "b": 493.88, "c2": 523.25}
	
	var playback = beep_player.get_stream_playback()
	var frequencies = []
	var tone_durations = [] # In sec
	var delay_between_tones = 0.2 # In sec
	var default_tone_length = 0.15
	
	# Define the tones and durations in the if statements and then play through them after 
	if type == "wall":
		frequencies = [tones["a"]]
		tone_durations = [0.15]
			
	elif type == "paddle":
		frequencies = [tones["c"]]
		tone_durations = [0.15]
		pass
	
	elif type == "coin":
		# b + g
		frequencies = [tones["b"], tones["g"]]
		tone_durations = [0.15, 0.15]
		pass
	
	elif type == "hit_player":
		# c2 + a
		frequencies = [tones["c2"], tones["a"]]
		tone_durations = [0.15, 0.15]
	
	elif type == "sweep":
		# Sweep through defined notes
		frequencies = [tones["c"], tones["d"], tones["e"], tones["f"], tones["g"], tones["a"], tones["b"], tones["c2"]]
		for i in range(len(frequencies)):
			tone_durations.append(0.15)
		delay_between_tones = 0.5
	
	else:
		pass
	
	# If tone_durations is empty then use default length
	if len(tone_durations) == 0:
		for i in range(len(frequencies)):
			tone_durations.append(default_tone_length)
	# Play the defined sounds
	for i in range(len(frequencies)):
		if i != 0: # Delay between tones
			await delay(delay_between_tones)
		
		var samples = int(generator.mix_rate * tone_durations[i])
		for j in range(samples):
			var t = j / generator.mix_rate
			if fmod(t * frequencies[i], 1.0) < 0.5:
				var value = 0.5
				playback.push_frame(Vector2(value, value))
			else:
				var value = -0.5
				playback.push_frame(Vector2(value, value))
		


func delay(time: float = 1) -> void:
	await get_tree().create_timer(time).timeout
