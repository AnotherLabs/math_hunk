extends Node2D

@export var red_duck_scene: PackedScene
@export var correct_result: int
@onready var life_manager = $CanvasLayer/LifeManager
var operation_running := false
var was_duck_clicked := false
var click_processed := false



# Called when the node enters the scene tree for the first time.
func _ready():
	life_manager.connect("game_over", Callable(self, "_on_game_over"))
	new_operation()

func new_operation():
	if operation_running:
		return
	operation_running = true
	var a = randi_range(1, 100)
	var b = randi_range(1, 100)
	correct_result = a + b
	$Operacion.text = "¿Cuánto es %d + %d?" % [a, b]
	
	var options = [correct_result]
	while options.size() < 3:
		var extra = randi_range(1, 20)
		if extra != correct_result and extra not in options:
			options.append(extra)
	options.shuffle()
	
	for i in range(options.size()):
		var duck = red_duck_scene.instantiate()
		duck.value = options[i]
		duck.position = Vector2(200 + i * 300, 610)
		duck.add_to_group("ducks")
		add_child(duck)
	operation_running = false
	
	
#func check_shot(value: int):
#	if value == correct_result:
#		print("Correct!")
#		get_tree().call_group("ducks", "stop_duck")
#		delete_all_ducks()
#		new_operation()
#	else:
#		print("Wrong or random click.")
#		life_manager.lose_life()

func check_shot(value: int):
	if value == correct_result:
		print("Correct!")
		delete_all_ducks()
		new_operation()
	else:
		print("Wrong or random click.")
		life_manager.lose_life()

	click_processed = false



func stop_all_ducks():
	for child in get_children():
		if child.has_method("stop"):
			child.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().get_nodes_in_group("ducks").is_empty():
		new_operation()
	
func delete_all_ducks():
	for duck in get_tree().get_nodes_in_group("ducks"):
		duck.queue_free()
	await get_tree().create_timer(0.5).timeout
	
func _on_game_over():
	for duck in get_tree().get_nodes_in_group("ducks"):
		duck.queue_free()
		
	life_manager.reset_lives()
	new_operation()
#
#func _unhandled_input(event):
#	if click_processed:
#		return
#
#	if event is InputEventMouseButton and event.pressed:
#		if not was_duck_clicked:
#			click_processed = true
#			check_shot(-1)
#		was_duck_clicked = false
#		click_processed = true

