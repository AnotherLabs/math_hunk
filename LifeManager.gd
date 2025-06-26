extends Node

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

var lives := 3
@onready var hearts := $HeartsContainer.get_children()

func _ready():
	reset_lives()

func lose_life():
	if lives <= 0:
		return
	lives -= 1
	update_hearts()
	if lives == 0:
		print("Game Over")
		emit_signal("game_over")

func reset_lives():
	lives = 3
	update_hearts()

func update_hearts():
	for i in range(hearts.size()):
		hearts[i].texture = full_heart if i < lives else empty_heart
		
signal game_over
