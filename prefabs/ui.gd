extends CanvasLayer


const TRAVEL_SPEED := 0.001


var _distance_traveled := 0.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var player := get_node("/root/game/player") as Node2D
	var ship := get_node("/root/game/ship") as Node2D

	$control/distance.text = "%.0fm" % ((player.global_position - ship.global_position).length() / 15.0)
	$control/health.text = "%.0f%%" % ( float(ship.alive_parts) / ship.total_parts * 100)
	$control/traveled.text = "distance traveled: %.3f l.y." % (_distance_traveled)

	_distance_traveled += delta * TRAVEL_SPEED
