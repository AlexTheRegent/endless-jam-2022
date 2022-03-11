extends KinematicBody2D


var direction := Vector2.ZERO
var speed := 200.0


func _ready() -> void:
	# direction = Vector2.LEFT
	pass


func _physics_process(_delta: float) -> void:
	var _velocity := move_and_slide(direction * speed)
