extends Sprite



const LIFETIME_DISTANCE_SQUARED := pow(2000.0, 2)
const BRIGHTNESS_MAX := 1.0
const BRIGHTNESS_MIN := 0.2
const BRIGHTNESS_DX := 0.15
const SPEED_MAX := 200.0


var direction := Vector2.ZERO
var speed := 50.0


var _brightness_target := 1.0


func _ready() -> void:
	# modulate.a = randf() * (BRIGHTNESS_MAX - BRIGHTNESS_MIN) + BRIGHTNESS_MIN
	direction = Vector2.LEFT


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.length_squared() > LIFETIME_DISTANCE_SQUARED:
		queue_free()

	if modulate.a == _brightness_target:
		_brightness_target = randf() * (BRIGHTNESS_MAX - BRIGHTNESS_MIN) + BRIGHTNESS_MIN

	var dx := (speed / SPEED_MAX) * BRIGHTNESS_DX * delta
	if modulate.a > _brightness_target:
		if modulate.a - dx < _brightness_target:
			modulate.a = _brightness_target
		else:
			modulate.a -= dx
	else:
		if modulate.a - dx > _brightness_target:
			modulate.a = _brightness_target
		else:
			modulate.a += dx
