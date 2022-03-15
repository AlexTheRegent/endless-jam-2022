extends KinematicBody2D


const BULLET := preload("res://prefabs/bullet.tscn")
const MAX_DISTANCE_FROM_SHIP := 85.0

export (float) var speed := 200.0

var _grabbed_entity: Node2D
var _root_sprite: Sprite


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	_handle_movement()
	_handle_shooting()
	_handle_grab()


func _handle_movement() -> void:
	var down := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var right := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var direction := Vector2(right, down).normalized()

	var _velocity := move_and_slide(direction * speed)
	# if global_position.distance_to(Vector2.ZERO) > MAX_DISTANCE_FROM_SHIP * 15.0:
	# 	global_position = (global_position - Vector2.ZERO).normalized() * MAX_DISTANCE_FROM_SHIP * 15.0

	if global_position.x > MAX_DISTANCE_FROM_SHIP * 15.0:
		global_position.x = MAX_DISTANCE_FROM_SHIP * 15.0
	elif global_position.x < -MAX_DISTANCE_FROM_SHIP * 15.0:
		global_position.x = -MAX_DISTANCE_FROM_SHIP * 15.0
	elif global_position.y > MAX_DISTANCE_FROM_SHIP * 15.0:
		global_position.y = MAX_DISTANCE_FROM_SHIP * 15.0
	elif global_position.y < -MAX_DISTANCE_FROM_SHIP * 15.0:
		global_position.y = -MAX_DISTANCE_FROM_SHIP * 15.0

	if _grabbed_entity == null:
		var mouse_position := get_local_mouse_position()
		$animated_sprite.flip_h = mouse_position.x < 0.0
		$weapon_end.position.x = abs($weapon_end.position.x) * (-1 if $animated_sprite.flip_h else 1)


func _handle_shooting() -> void:
	if _grabbed_entity != null:
		return

	if Input.is_action_just_pressed("shoot") == false:
		return

	var bullet := BULLET.instance() as Node2D
	get_node("/root/game/bullets").add_child(bullet)

	# bullet.global_rotation = atan(($weapon_end.global_position.y - get_global_mouse_position().y) / $weapon_end.global_position.x - get_global_mouse_position().x) # $weapon_end.global_position.angle_to(get_global_mouse_position()) - PI/4
	# prints($weapon_end.global_position, get_global_mouse_position())

	bullet.direction = (get_global_mouse_position() - $weapon_end.global_position).normalized()
	bullet.global_position = $weapon_end.global_position
	bullet.rotation = bullet.direction.angle()


func _handle_grab() -> void:
	$ray_cast_2d.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("use"):
		if _grabbed_entity == null:
			$ray_cast_2d.force_raycast_update()
			var collider := $ray_cast_2d.get_collider() as Node2D
			if collider == null or collider.get_parent().name != "junk":
				for junk in get_node("/root/game/junk").get_children():
					var colliders := junk.get_world_2d().direct_space_state.intersect_point(global_position, 1, [], 2, false, true) as Array
					if colliders.size() > 0:
						collider = colliders[0].collider

			if collider != null && collider.get_parent().name == "junk":
				collider.direction = Vector2.ZERO
				collider.monitorable = true
				_grabbed_entity = collider

				collider.position = collider.global_position - global_position
				collider.get_parent().remove_child(collider)
				add_child(collider)

				if collider.connect("attached", self, "_on_part_attached", [], CONNECT_ONESHOT) != OK:
					push_error("failed to connect 'attached' signal on %s" % collider.name)

				var ship := get_node("/root/game/ship") as Node2D
				var root := ship.get_node("roots/%s" % collider.name.substr(0, 7))

				_root_sprite = Sprite.new()
				_root_sprite.z_index = 100
				_root_sprite.texture = load("res://assets/sprites/root.png")
				root.add_child(_root_sprite)

				$animated_sprite.raise()
		else:
			_grabbed_entity.position = _grabbed_entity.global_position
			_grabbed_entity.rotation = _grabbed_entity.global_rotation
			_grabbed_entity.get_parent().remove_child(_grabbed_entity)
			get_node("/root/game/junk").add_child(_grabbed_entity)

			_grabbed_entity.disconnect("attached", self, "_on_part_attached")
			_on_part_attached()


func _on_part_attached() -> void:
	_root_sprite.queue_free()
	_grabbed_entity = null
	_root_sprite = null
