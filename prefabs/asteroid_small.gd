extends KinematicBody2D



const LIFETIME_DISTANCE_SQUARED := pow(2000.0, 2)
const EXPLOSION := preload("res://prefabs/explosion.tscn")


var direction := Vector2.ZERO
var speed := 200.0

var _rotation_speed := 0.0


func _ready() -> void:
	_rotation_speed = randf()


func _physics_process(_delta: float) -> void:
	var _velocity := move_and_slide(direction * speed)
	if global_position.length_squared() > LIFETIME_DISTANCE_SQUARED:
		queue_free()

	rotation_degrees += _rotation_speed


func hit(_bullet: Node2D) -> void:
	var explosion := EXPLOSION.instance()
	explosion.position = global_position
	get_node("/root/game").add_child(explosion)
	explosion.play("default")

	queue_free()
