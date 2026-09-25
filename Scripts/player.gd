extends CharacterBody2D

@onready var skins: Array[AnimatedSprite2D] = [
	$Skin1,
	$Skin2,
	$Skin3,
]

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_falling = false

# switch to random skin out of set
var active_skin: AnimatedSprite2D

func _ready():
	randomize()  # remove this line if you want the same skin every run while testing
	var chosen_index = randi() % skins.size()
	
	for i in skins.size():
		skins[i].visible = (i == chosen_index)
	
	active_skin = skins[chosen_index]
	active_skin.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		is_falling = true
	
	if is_falling and is_on_floor():
		is_falling = false
		landing_fx()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		active_skin.flip_h = false
	elif direction < 0:
		active_skin.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			active_skin.play("idle")
		else:
			active_skin.play("run")
	else:
		active_skin.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
const LANDING_SCENE = preload("res://scenes/landing_fx.tscn")

func landing_fx():
	var landing = LANDING_SCENE.instantiate()
	landing.process_mode = PROCESS_MODE_ALWAYS
	
	landing.global_position.x = self.global_position.x
	landing.global_position.y = self.global_position.y - 7
	
	get_tree().current_scene.add_child(landing)
