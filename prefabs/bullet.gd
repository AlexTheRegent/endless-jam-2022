extends KinematicBody2D



const LIFETIME_DISTANCE_SQUARED := pow(2000.0, 2)


var direction := Vector2.ZERO
var speed := 800.0


func _ready() -> void:
	# direction = Vector2.LEFT
	pass


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(direction * speed * delta)
	if collision != null:
		collision.collider.queue_free()
		queue_free()

	if global_position.length_squared() > LIFETIME_DISTANCE_SQUARED:
		queue_free()
