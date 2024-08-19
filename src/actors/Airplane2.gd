extends RigidBody2D

@export var elevator = 0
@export var elevator_deg = 0
@export var Fx = 0
@export var Fy = 0
@export var theta_deg = 0
@export var alpha_deg = 0
@export var My = 0
@export var Fx_screen = 0
@export var Fy_screen = 0
@export var test = 0
@export var max_vy = 0
@export var thrust = 0
@export var airplane_rotation = 0
@export var airplane_position = 0
var power_setting = 0



const bulletPath = preload("res://Bullet.tscn")
const scriptPath = preload("res://bullet.gd")
const bombPath = preload("res://Bomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#linear_velocity.x = 10000
	#thrust = 1000000
	#rotation_degrees = -15
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vy = linear_velocity.y
	
	if(abs(vy)>max_vy):
		max_vy = abs(vy)
		
	
	pass
	
func shoot():
	var bullet = bulletPath.instantiate()
	#var bscript = scriptPath.instantiate()
	
	get_parent().add_child(bullet)
	bullet.get_child(0).set_speed(linear_velocity)
	#bullet.get_child(0).set_speed(Vector2(6000*cos(rotation), 6000*sin(rotation)))
	bullet.get_child(0).set_rotation(rotation)
	#bullet.position = $Node2D/Marker2D.global_position
	bullet.global_position = $Node2D/Marker2D.global_position
	test = $Node2D/Marker2D.global_position
	$AudioStreamPlayer.play(0)
	$Timer.start()
	
func bomb():
	var bomb = bombPath.instantiate()
	
	get_parent().add_child(bomb)
	bomb.get_child(0).set_speed(linear_velocity)
	bomb.get_child(0).set_rotation(rotation)
	
	bomb.global_position = $BombNode2D/Marker2D.global_position
	$BombTimer.start()
	
	
func _physics_process(delta):
	#if Input.is_action_pressed("Elevate down"):
		#Fy = Fy - 50000
	#	elevator_deg -= 0.1
	#if Input.is_action_pressed("Elevate up"):
		#Fy = Fy + 50000
	#	elevator_deg += 0.1
	if Input.is_action_just_pressed("Add thrust"):
		power_setting += 1
		
	if Input.is_action_just_pressed("Subtract thrust"):
		power_setting -= 1
	#thrust = 500000
	if Input.is_action_pressed("Shoot"):
		if $Timer.time_left < 0.01:
			shoot()
		
	if Input.is_action_pressed("Bomb"):
		bomb()
		
	
	power_setting = clamp(power_setting, 0, 5)
	thrust = power_setting * 240000
	
	elevator_deg = Input.get_axis("Elevate down", "Elevate up")*30
	
	var V_body = Vector2()
	V_body.x = linear_velocity.x*cos(rotation) + linear_velocity.y*sin(rotation)
	V_body.y = -linear_velocity.x*sin(rotation) + linear_velocity.y*cos(rotation)
	var aoa
	var aoa_unclamped
	
	aoa = atan2(V_body.y, V_body.x)
	aoa_unclamped = aoa
	alpha_deg = rad_to_deg(aoa)
	aoa = clamp(aoa, deg_to_rad(-15), deg_to_rad(15))
	
	var V2
	var lift
	var drag
	V2 = linear_velocity.length_squared()
	lift = .1*aoa_unclamped*V2
	drag = .01*V2
	#test = drag
	
	Fx = -cos(aoa_unclamped)*drag + sin(aoa_unclamped)*lift
	Fy = -sin(aoa_unclamped)*drag - cos(aoa_unclamped)*lift
	
	Fx = thrust + Fx
	
	var F_screen = Vector2()
	F_screen.x = Fx*cos(rotation) - Fy*sin(rotation)
	F_screen.y = Fx*sin(rotation) + Fy*cos(rotation)
	#Fx_screen = F_screen.x
	#Fy_screen = F_screen.y
	apply_central_force(F_screen)
	

	

	#alpha_deg = rad_to_deg(aoa)
	apply_torque(elevator_deg*-1000000 + aoa*10000000+angular_velocity*-3)
	theta_deg = elevator_deg*-1000000 + aoa*10000000+angular_velocity*-3
	
	
	airplane_position = get_global_position()
	airplane_rotation = rotation
	#rotation = atan2(linear_velocity.y, linear_velocity.x)
	
	#print(airplane_position.y)
	$"Camera2D/CanvasLayer/Altitude Bar".global_position.y = airplane_position.y * 0.05 + 1050
	
	$"Camera2D/CanvasLayer2/speedometer bar".global_rotation = abs(linear_velocity.length())*0.00028
	print($"Camera2D/CanvasLayer/Altitude Bar".global_position.y)
	
	#Altitude "0" will be 925
	
