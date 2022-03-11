extends KinematicBody2D



const LIFETIME_DISTANCE_SQUARED := pow(2000.0, 2)


var direction := Vector2.ZERO
var speed := 200.0


func _ready() -> void:
	# direction = Vector2.LEFT
	pass


func _physics_process(_delta: float) -> void:
	var _velocity := move_and_slide(direction * speed)
	if global_position.length_squared() > LIFETIME_DISTANCE_SQUARED:
		queue_free()
