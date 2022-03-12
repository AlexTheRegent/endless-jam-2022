extends Sprite



const LIFETIME_DISTANCE_SQUARED := pow(2000.0, 2)


var direction := Vector2.ZERO
var speed := 200.0


func _ready() -> void:
	direction = Vector2.LEFT


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.length_squared() > LIFETIME_DISTANCE_SQUARED:
		queue_free()
