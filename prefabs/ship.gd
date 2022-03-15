extends Node2D


const GLIDE_SPEED := 3.0
const GLIDE_RANGE := 10.0


var total_parts := 0
var alive_parts := 0


var _glide_target := Vector2.ZERO


onready var _roots_nodes := $roots
onready var _parts_nodes := $parts


func _ready() -> void:
	for root in _roots_nodes.get_children():
		if root.connect("area_entered", self, "_on_area_entered", [root]) != OK:
			push_error("failed to connect 'damaged' signal on %s" % root.name)

	for part in _parts_nodes.get_children():
		if part.connect("damaged", self, "_on_part_damaged") != OK:
			push_error("failed to connect 'damaged' signal on %s" % part.name)
		if part.connect("repaired", self, "_on_part_repaired") != OK:
			push_error("failed to connect 'repaired' signal on %s" % part.name)

		total_parts += 3

	alive_parts = total_parts


func _physics_process(delta: float) -> void:
	if global_position == _glide_target:
		_glide_target = Vector2(randf() * GLIDE_RANGE - GLIDE_RANGE / 2.0, randf() * GLIDE_RANGE - GLIDE_RANGE / 2.0)

	var glide_direction := (_glide_target - global_position)
	if glide_direction.length() > GLIDE_SPEED * delta:
		global_position += glide_direction.normalized() * GLIDE_SPEED * delta
	else:
		global_position = _glide_target


func _on_part_damaged() -> void:
	var ship_lost_health := (total_parts - alive_parts) as int

	if ship_lost_health > 25:
		if get_tree().change_scene("res://scenes/game_over.tscn") != OK:
			push_error('failed to change scene')

	alive_parts -= 1


func _on_part_repaired() -> void:
	alive_parts += 1


func _on_area_entered(part: Area2D, root: Node2D) -> void:
	if root.name != part.name.substr(0, 7):
		return

	var parts := _parts_nodes.get_node(root.name)
	var part_num := int(part.name.substr(8))
	if part_num != 1:
		var part_tail := parts.get_tail() as Node2D
		if part_tail == null:
			return

		var tail_name := part_tail.name as String
		var tail_num := int(tail_name.substr(8))
		if tail_num + 1 != part_num:
			return

	parts.attach(part)
