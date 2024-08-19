extends RigidBody2D

var speed

var start_position
var first_call = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_speed(speedin):
	linear_velocity = speedin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_call:
		start_position = global_position
		first_call = false
	
	var V_body = Vector2()
	V_body.x = linear_velocity.x*cos(rotation) + linear_velocity.y*sin(rotation)
	V_body.y = -linear_velocity.x*sin(rotation) + linear_velocity.y*cos(rotation)
	var aoa
	var aoa_unclamped
	
	aoa = atan2(V_body.y, V_body.x)
	aoa_unclamped = aoa
	aoa = clamp(aoa, deg_to_rad(-15), deg_to_rad(15))
	
	var V2
	var lift
	var drag
	V2 = linear_velocity.length_squared()
	lift = .1*aoa_unclamped*V2
	drag = .01*V2
	#test = drag
	
	var Fx = -cos(aoa_unclamped)*drag
	var Fy = -sin(aoa_unclamped)*drag
	
	
	var F_screen = Vector2()
	F_screen.x = Fx*cos(rotation) - Fy*sin(rotation)
	F_screen.y = Fx*sin(rotation) + Fy*cos(rotation)
	#Fx_screen = F_screen.x
	#Fy_screen = F_screen.y
	apply_central_force(F_screen)
	

	

	#alpha_deg = rad_to_deg(aoa)
	apply_torque(aoa*10000000+angular_velocity*-3)
	
		
	
