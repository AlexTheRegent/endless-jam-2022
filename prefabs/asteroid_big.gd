extends "res://prefabs/asteroid_small.gd"


const SMALL_ASTEROID_DISTANCE_SPREAD := 80.0
const SMALL_ASTEROID_ANGLE_SPREAD := 15.0


func hit(bullet: Node2D) -> void:
	if randf() < 0.25:
		var spawn_pos_1 := global_position - Vector2(randf() * SMALL_ASTEROID_DISTANCE_SPREAD, randf() * SMALL_ASTEROID_DISTANCE_SPREAD)
		var spawn_pos_2 := global_position + Vector2(randf() * SMALL_ASTEROID_DISTANCE_SPREAD, randf() * SMALL_ASTEROID_DISTANCE_SPREAD)
		var spread_angle_1 := randf() * PI/8
		var spread_angle_2 := -randf() * PI/8

		get_node("/root/game").spawn_asteroid(spawn_pos_1, direction.rotated(spread_angle_1), "small")
		get_node("/root/game").spawn_asteroid(spawn_pos_2, direction.rotated(spread_angle_2), "small")

	.hit(bullet)
