extends CanvasLayer

var INACTIVE_BUTTON_COLOR:Color = Color.hex(0x4d4d4d)
var ACTIVE_BUTTON_COLOR:Color = Color.hex(0x5a5a5a) 

@onready var retry_button = $RetryButton
@onready var retry_button_color = $RetryButton/RetryButtonColor
@onready var quit_button = $QuitButton
@onready var quit_button_color = $QuitButton/QuitButtonColor

@onready var background = $Background

@onready var timer = $Timer

@onready var bsod = $BSOD
var previous_mode

var bsod_cleared:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fullscreen and unhide BSOD
	previous_mode = DisplayServer.window_get_mode()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	bsod.visible = false
	
	timer.start(3)
	
	print("RetryButton ready, layer:", retry_button.collision_layer, "mask:", retry_button.collision_mask)
	retry_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	retry_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	DisplayServer.window_set_mode(previous_mode)
	bsod.visible = false
	#bsod.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_retry_button_mouse_entered() -> void:
	print("hovering")
	retry_button_color.color = ACTIVE_BUTTON_COLOR
	

func _on_retry_button_mouse_exited() -> void:
	print("not hovering")
	retry_button_color.color = INACTIVE_BUTTON_COLOR
