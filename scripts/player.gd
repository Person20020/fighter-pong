extends CharacterBody2D


const SPEED = 220.0
const JUMP_VELOCITY = -300.0
const DAMPENING_PERCENT = 0.3
const MIN_VELOCITY = 1
const VELOCITY_INCREASE = .1


var last_velocity = {"x": 0, "y": 0}
var point_in_acceleration = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if (Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		# velocity.x = direction * SPEED
		if point_in_acceleration <= 1:
			point_in_acceleration = exp(VELOCITY_INCREASE + point_in_acceleration)/exp(1)
		velocity.x = direction * SPEED * point_in_acceleration
		if abs(velocity.x) > SPEED:
			velocity.x = SPEED * (abs(velocity.x) / velocity.x)
		
		
	else:
		# velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = last_velocity.x * abs(1 - DAMPENING_PERCENT)
		
		if abs(velocity.x) <= MIN_VELOCITY:
			velocity.x = 0
	
		point_in_acceleration = 0
	
	#if not velocity.x == last_velocity.x or not velocity.y == last_velocity.y:
	#	print(velocity)
	
	last_velocity.x = velocity.x
	last_velocity.y = velocity.y
	
	move_and_slide()
