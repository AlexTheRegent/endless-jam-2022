tool
extends EditorPlugin


var _dock: Button


func _enter_tree() -> void:
	_dock = load("res://addons/colshapes/plugin.tscn").instance()
	add_control_to_container(CONTAINER_TOOLBAR, _dock)
	_dock.connect("pressed", self, "_on_pressed")


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, _dock)
	_dock.queue_free()


func _on_pressed() -> void:
	toggle_visibility(get_tree().get_edited_scene_root().get_children())


func toggle_visibility(nodes: Array) -> void:
	for node in nodes:
		if node is CollisionPolygon2D:
			node.visible = !node.visible

		if node.get_child_count() != 0:
			toggle_visibility(node.get_children())
