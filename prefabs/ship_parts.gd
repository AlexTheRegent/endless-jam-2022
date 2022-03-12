extends Node2D


signal repaired
signal damaged


const OUTLINE_SHADER := preload("res://assets/shaders/outline_shader.tres")
const OUTLINE_COLOR := Color(0, 1, 1)


var _tail: Area2D


func _ready() -> void:
	update_tail()


func get_tail() -> Area2D:
	var child_count := get_child_count()
	if child_count == 0:
		return null

	return get_children()[child_count - 1]


func update_tail() -> void:
	_tail = get_tail()
	if _tail == null:
		return

	_tail.monitoring = true
	if _tail.connect("body_entered", self, "_on_body_entered") != OK:
		push_error("failed to connect 'body_entered' signal on %s" % _tail.name)


func detach(direction: Vector2) -> void:
	_tail.monitoring = false

	_tail.position = _tail.global_position
	_tail.get_parent().remove_child(_tail)

	get_node("/root/game/junk").add_child(_tail)
	_tail.direction = direction

	_tail.get_node("sprite").material = ShaderMaterial.new()
	_tail.get_node("sprite").material.shader = OUTLINE_SHADER
	_tail.get_node("sprite").material.set_shader_param("outline_color", OUTLINE_COLOR)
	_tail.get_node("sprite").material.set_shader_param("width", 1.0)

	_tail.set_collision_layer_bit(1, true)
	update_tail()


func attach(part: Area2D) -> void:
	if _tail != null:
		_tail.disconnect("body_entered", self, "_on_body_entered")
		_tail.call_deferred("set_monitoring", false)

	part.call_deferred("set_monitorable", false)
	part.call_deferred("set_monitoring", true)
	part.get_node("sprite").material = null
	_tail = part

	_tail.get_parent().remove_child(_tail)
	call_deferred("add_child", _tail)
	_tail.position = Vector2.ZERO

	emit_signal("repaired")
	part.emit_signal("attached")
	part.set_collision_layer_bit(1, false)
	if part.connect("body_entered", self, "_on_body_entered") != OK:
		push_error("failed to connect 'body_entered' signal on %s" % part.name)


func _on_body_entered(body: Node2D) -> void:
	if body.get_parent().name != "asteroids":
		return

	_tail.disconnect("body_entered", self, "_on_body_entered")
	emit_signal("damaged")
	body.queue_free()

	call_deferred("detach", body.direction)
