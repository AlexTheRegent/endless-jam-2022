extends CanvasLayer


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var player := get_node("/root/game/player") as Node2D
	var ship := get_node("/root/game/ship") as Node2D
	$control/distance.text = "%.0fm" % ((player.global_position - ship.global_position).length() / 15.0)
	$control/health.text = "%.0f%%" % ( float(ship.alive_parts) / ship.total_parts * 100)
