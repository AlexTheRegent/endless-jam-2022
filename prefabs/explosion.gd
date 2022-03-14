extends AnimatedSprite


func _ready() -> void:
	if connect("animation_finished", self, "_on_animation_finished") != OK:
		push_error('failed to connect "animation_finished" signal')
		return


func _on_animation_finished() -> void:
	queue_free()
