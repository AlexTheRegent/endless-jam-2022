extends KinematicBody2D


export (float) var speed := 200.0

var _grabbed_entity: Node2D


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var down := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var right := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var direction := Vector2(right, down).normalized()

	var _velocity := move_and_slide(direction * speed)

	if _grabbed_entity == null:
		var mouse_position := get_local_mouse_position()
		$animated_sprite.flip_h = mouse_position.x < 0.0

	$ray_cast_2d.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("use"):
		if _grabbed_entity == null:
			$ray_cast_2d.force_raycast_update()
			var collider := $ray_cast_2d.get_collider() as Node2D
			if collider != null && collider.get_parent().name == "junk":
				collider.direction = Vector2.ZERO
				collider.monitorable = true
				_grabbed_entity = collider

				collider.position = collider.global_position - global_position
				collider.get_parent().remove_child(collider)
				add_child(collider)

				if collider.connect("attached", self, "_on_part_attached", [], CONNECT_ONESHOT) != OK:
					push_error("failed to connect 'attached' signal on %s" % collider.name)
		else:
			_grabbed_entity.position = _grabbed_entity.global_position
			_grabbed_entity.rotation = _grabbed_entity.global_rotation
			_grabbed_entity.get_parent().remove_child(_grabbed_entity)
			get_node("/root/game/junk").add_child(_grabbed_entity)

			_grabbed_entity.disconnect("attached", self, "_on_part_attached")
			_grabbed_entity = null


func _on_part_attached() -> void:
	_grabbed_entity = null
