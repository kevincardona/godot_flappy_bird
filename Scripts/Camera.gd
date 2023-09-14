extends Camera2D

@onready var player = get_node("/root/Game/Player")

func _process(_delta):
	if(player):
		self.position.x = player.position.x + 300
