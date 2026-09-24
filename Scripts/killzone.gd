extends Area2D
@onready var timer = $Timer

func _on_body_entered(body):
	print ("You straight up died")
	Engine.time_scale = 0.5
	body.get_node("AnimatedSprite2D").flip_v = true
	body.get_node("CollisionShape2D").queue_free()
	
	GameManager.explode(body.global_position)
	
	timer.start()
	%DeathSound.play()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
