extends Node2D

const SCROLL_SPEED = 50  # Adjust the scroll speed as needed

func _process(delta):
	# Scroll the background and floor to the left
	var x_offset = SCROLL_SPEED * delta
	for tilemap in get_children():
		if tilemap is TileMap:
			tilemap.position.x -= x_offset

			# Reset the position when it goes out of view
			if tilemap.position.x < -tilemap.rect_min_size.x:
				tilemap.position.x = 0
