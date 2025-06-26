extends Area2D

@export var value: int = 0
@export var speed_y: float = randi_range(100, 400)
var is_stopped := false
var ducks_animations = ["green_duck", "red_duck", "blue_duck"]

var duck_type: String = ducks_animations.pick_random()
@onready var duck_sprite = $AnimatedSprite2D



@onready var lbl = $Label
@export var dead_texture: Texture2D
var is_dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	lbl.text = str(value)
	add_to_group("ducks")
	duck_sprite.play(duck_type)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_stopped:
		return
	position.y -= speed_y * delta
	
	if position.y < -100:
		queue_free()



func stop():
	is_stopped = true
	duck_sprite.stop()
	
#func _input_event(_viewport, event, _shape_idx):
#	if event is InputEventMouseButton and event.pressed and not is_dead:
#		is_dead = true
#		get_parent().was_duck_clicked = true
#		get_parent().call("check_shot", value)
#		queue_free()
#		get_viewport().set_input_as_handled()
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and not is_dead:
		is_dead = true
		var parent = get_parent()
		if parent.has_method("check_shot"):
			parent.was_duck_clicked = true
			parent.check_shot(value)
		queue_free()
# puto el que lo lea


