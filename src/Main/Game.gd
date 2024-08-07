extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay = load("res://src/Main/debugLayer.tscn").instantiate()
	overlay.add_stat("Position", $Level/Airplane, "position", false)
	overlay.add_stat("Velocity", $Level/Airplane, "get_linear_velocity", true)
	overlay.add_stat("Theta", $Level/Airplane, "theta_deg", false)
	overlay.add_stat("Alpha", $Level/Airplane, "alpha_deg", false)
	overlay.add_stat("Elevator", $Level/Airplane, "elevator_deg", false)
	overlay.add_stat("Fx", $Level/Airplane, "Fx", false)
	overlay.add_stat("Fy", $Level/Airplane, "Fy", false)
	overlay.add_stat("My", $Level/Airplane, "My", false)
	overlay.add_stat("Max_vy", $Level/Airplane, "max_vy", false)
	overlay.add_stat("Thrust", $Level/Airplane, "thrust", false)
	overlay.add_stat("YThrust", $Level/Airplane, "Fy", false)
	overlay.add_stat("test", $Level/Airplane, "test", false)
	add_child(overlay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
