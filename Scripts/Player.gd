extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -800.0
const ROTATION_SPEED = 20.0
const START_X_POS = 150
const START_Y_POS = 320

@onready var game = get_node("/root/Game")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sprite
var animation_player

func reset():
	position.x = START_X_POS
	position.y = START_Y_POS
	sprite.rotation = 0
	velocity = Vector2()

func _physics_process(delta):
	if game.is_playing:
		_move_player(delta)

func _move_player(delta):
	velocity.x = SPEED
	velocity.y += gravity * delta
	

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		$AnimationPlayer.play("bird--flapping") 

	var target_rotation = lerp(sprite.rotation, atan(velocity.y / 400), ROTATION_SPEED * delta)
	sprite.rotation = target_rotation

	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		game.stop()

func _ready():
	sprite = get_node("Bird")
