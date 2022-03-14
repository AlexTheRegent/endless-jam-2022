extends "res://prefabs/asteroid_small.gd"


const SMALL_ASTEROID_DISTANCE_SPREAD := 80.0
const SMALL_ASTEROID_ANGLE_SPREAD := 15.0


func hit(bullet: Node2D) -> void:
	if randf() < 0.25:
		get_node("/root/game").spawn_asteroid(global_position - Vector2(randf() * SMALL_ASTEROID_DISTANCE_SPREAD, randf() * SMALL_ASTEROID_DISTANCE_SPREAD), direction, "small")
		get_node("/root/game").spawn_asteroid(global_position + Vector2(randf() * SMALL_ASTEROID_DISTANCE_SPREAD, randf() * SMALL_ASTEROID_DISTANCE_SPREAD), direction, "small")

	.hit(bullet)
