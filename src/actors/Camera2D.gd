extends Camera2D

var cam_pos = null
var air_pos = null
var air_rot = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_pos = get_global_position()
	air_pos = get_parent().airplane_position
	air_rot = get_parent().airplane_rotation
	
	offset.x = 2000*cos(air_rot)
	offset.y = 2000*sin(air_rot)
	pass
