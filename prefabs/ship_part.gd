extends Area2D


#warning-ignore:UNUSED_SIGNAL
signal attached # (emitted from ship.gd)


var direction := Vector2.ZERO
var speed := 20.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	global_position += (direction * speed * delta)
