extends Control


func _ready() -> void:
	if $button.connect("pressed", self, "_on_pressed") != OK:
		push_error('failed to connect "pressed" signal')


func _on_pressed() -> void:
	if get_tree().change_scene("res://scenes/game.tscn") != OK:
		push_error('failed to change scene')
