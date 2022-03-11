extends Node2D


signal damaged


var _tail: Area2D


func _ready() -> void:
	# _tail = get_tail()
	# _tail.monitoring = true

	# if _tail.connect("body_entered", self, "_on_body_entered") != OK:
	# 	push_error("failed to connect 'body_entered' signal on %s" % _tail.name)

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
	# _tail.monitorable = true

	_tail.position = _tail.global_position
	_tail.get_parent().remove_child(_tail)

	get_node("/root/game/junk").add_child(_tail)
	_tail.direction = direction

	update_tail()


func attach(part: Area2D) -> void:
	if _tail != null:
		_tail.disconnect("body_entered", self, "_on_body_entered")
		_tail.call_deferred("set_monitoring", false)

	part.call_deferred("set_monitorable", false)
	part.call_deferred("set_monitoring", true)
	_tail = part

	_tail.get_parent().remove_child(_tail)
	call_deferred("add_child", _tail)
	_tail.position = Vector2.ZERO

	part.emit_signal("attached")
	if part.connect("body_entered", self, "_on_body_entered") != OK:
		push_error("failed to connect 'body_entered' signal on %s" % part.name)


func _on_body_entered(body: Node2D) -> void:
	_tail.disconnect("body_entered", self, "_on_body_entered")
	emit_signal("damaged")
	body.queue_free()

	call_deferred("detach", (_tail.global_position - body.global_position).normalized())
