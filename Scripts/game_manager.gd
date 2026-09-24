extends Node

var score = 0
@onready var score_label = $ScoreLabel

const EXPLOSION_SCENE = preload("res://scenes/explosion.tscn")

func add_point():
	score += 1
	score_label.text = "You collected\n" + str(score) + " coins."

func explode(pos):
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.process_mode = PROCESS_MODE_ALWAYS
	explosion.global_position = pos
	get_tree().current_scene.add_child(explosion)
