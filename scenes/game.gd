extends Node2D


const ASTEROID := preload("res://prefabs/asteroid.tscn")
const SPAWN_RANGE := 300.0


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if randf() < 0.01:
		# var asteroid := ASTEROID.instance()
		# $asteroids.add_child(asteroid)

		# var angle := randf() * 360.0
		# asteroid.global_position = Vector2(cos(deg2rad(angle)) * SPAWN_RANGE, sin(deg2rad(angle)) * SPAWN_RANGE)
		pass

	# if Input.is_key_pressed(KEY_LEFT):
	# 	var asteroid := ASTEROID.instance()
	# 	$asteroids.add_child(asteroid)

	# 	asteroid.global_position = get_global_mouse_position()
	# 	asteroid.direction = Vector2.LEFT


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.echo == false:
			if event.scancode == KEY_LEFT:
				spawn_asteroid(get_global_mouse_position(), Vector2.LEFT)
			elif event.scancode == KEY_RIGHT:
				spawn_asteroid(get_global_mouse_position(), Vector2.RIGHT)
			elif event.scancode == KEY_UP:
				spawn_asteroid(get_global_mouse_position(), Vector2.UP)
			elif event.scancode == KEY_DOWN:
				spawn_asteroid(get_global_mouse_position(), Vector2.DOWN)


func spawn_asteroid(position: Vector2, direction: Vector2, speed := 200.0) -> void:
	var asteroid := ASTEROID.instance()
	$asteroids.add_child(asteroid)

	asteroid.global_position = position
	asteroid.direction = direction
	asteroid.speed = speed
