extends Node2D


const ASTEROID := preload("res://prefabs/asteroid.tscn")
const SPAWN_RANGE := 1000.0
const SPREAD_ANGLE := 30.0


func _ready() -> void:
	randomize()


func _physics_process(_delta: float) -> void:
	if randf() < 0.01:
		var angle := randf() * 360.0
		var gpos := Vector2(cos(deg2rad(angle)) * SPAWN_RANGE, sin(deg2rad(angle)) * SPAWN_RANGE)

		var dir_angle := angle + (180.0 - randf() * SPREAD_ANGLE - SPREAD_ANGLE / 2.0)
		var gtarget := Vector2(cos(deg2rad(dir_angle)) * SPAWN_RANGE, sin(deg2rad(dir_angle)) * SPAWN_RANGE)

		var gdir := (gtarget - gpos).normalized()
		spawn_asteroid(gpos, gdir)
		pass


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
