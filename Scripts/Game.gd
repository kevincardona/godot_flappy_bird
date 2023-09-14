extends Node2D

@export var pipe_vertical_spacing: int = 830
@export var pipe_horizontal_spacing: int = 300
@export var pipe_spawn_interval: float = 1.0
@export var is_playing: bool = false
@export var game_over: bool = false
@onready var player = get_node("/root/Game/Player")
@onready var scoreboard = get_node("/root/Game/Camera/Scoreboard")

var min_bottom_pipe_y: int = 191
var max_bottom_pipe_y: int = 445
var pipe_scene: PackedScene
var pipe_instances = []

var score: int = 0

func reset():
	game_over = false
	score = 0
	player.reset()
	clear_pipes()  # Clear pipes when resetting

func clear_pipes():
	for pipe in pipe_instances:
		pipe.queue_free()
	pipe_instances.clear()  # Clear the array

func _ready():
	pipe_scene = preload("res://Prefabs/Pipes.tscn")

func start():
	$Timer.start(pipe_spawn_interval)
	is_playing = true

func stop():
	game_over = true
	is_playing = false
	$Timer.stop()

func _on_timer_timeout():
	if is_playing:
		print("Creating new pipe")
		var pipe_instance = pipe_scene.instantiate()
		pipe_instance.position.x = $Player.position.x + 1050
		pipe_instance.position.y = randi() % (max_bottom_pipe_y - min_bottom_pipe_y) + min_bottom_pipe_y
		pipe_instance.z_index = -1
		pipe_instances.append(pipe_instance)
		add_child(pipe_instance)

func _process(delta):
	scoreboard.text = "[center]%d[/center]" % score
	if game_over && Input.is_action_just_pressed("jump"):
		reset()
	elif !is_playing && Input.is_action_just_pressed("jump"):
		start()
	for pipe in pipe_instances:
		if pipe.position.x < $Player.position.x - 400:
			pipe_instances.erase(pipe)
			pipe.queue_free()
			score += 1
