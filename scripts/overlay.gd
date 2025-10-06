extends CanvasLayer

@export var max_hearts : int = 3
var current_hearts: int


@onready var heart_container = $HealthContainer

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
