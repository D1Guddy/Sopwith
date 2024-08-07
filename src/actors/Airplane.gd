extends RigidBody2D


# Settings
@export var elevator = 0
@export var elevator_deg = 0
@export var thrust = 0
@export var theta_deg = 0
@export var alpha_deg = 0
@export var My = 0
@export var Fx_screen = 0
@export var Fy_screen = 0
@export var test = 0

# Aerodynamics
var b      = 118.0/12.0*0.3048  # wing span, m
var lref   = 10.8/12.0*0.3048 # reference length, m
var sref   = b*lref     # reference area, m^2
var CL0    = 0 #0.5
var CLa    = 5.8665
var CLd    = 0.5608
var amin   = -15*PI/180  # alpha at min CL
var amax   = 15*PI/180   # alpha at max CL
var CLmax  = CLa*15*PI/180 # Max CL at 15 degrees
var CD0    = 0.3
var CDd    = -0.0145
var oswald = 0.8 # oswald efficiency factor
var RA     =  b*b/sref # aspect ratio, span^2/area
var Cma    = -1.3394
var Cmd    = -1.3207
var Cmq    = -8.5377
var rho    = 1.2250 # air density, kg/m^3
var drate  =  1*PI/180 # elevator slew rate, rad/s
var dmin   = -10*PI/180 # min elevator angle, rad
var dmax   = 10*PI/180 # max elevator angle, rad
var tmin   = 0 # min thrust setting
var tmax   = 100 # max thrust setting
var trate  = 2 #


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(200, 0)
	gravity_scale = 1
	rotation = -5*PI/180
	thrust = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if Input.is_action_just_released("ui_right"):
		elevator += 1*PI/180
	if Input.is_action_just_released("ui_left"):
		elevator -= 1*PI/180
	if Input.is_action_pressed("ui_up"):
		thrust += 1
	if Input.is_action_pressed("ui_down"):
		thrust -= 1
	
	elevator = clamp(elevator, dmin, dmax)
	elevator_deg = elevator*180/PI
	thrust = clamp(thrust, tmin, tmax)
	
	var vel_screen = get_linear_velocity()/10
	var q = -angular_velocity
	var theta = rotation
	theta_deg = theta*180/PI
	
	var vel = Vector2()
	vel.x =  vel_screen.x*cos(theta) + vel_screen.y*sin(theta)
	vel.y = -vel_screen.x*sin(theta) + vel_screen.y*cos(theta)
	var alpha = atan2(vel.y, vel.x)
	var dive = atan2(vel_screen.y, vel_screen.x)
	alpha_deg = alpha*180/PI
	
	var Q = 0.5*rho*vel.length_squared()
#	var CL = CL0 + CLa*alpha
#	CL = clamp(CL, -CLmax, CLmax)
	
	var CL = 0
	var CD = 0
	var Cm = 0
	if alpha < -PI/2:
		CL = 0
	elif alpha < amin:
		CL = ((CL0 + CLa*amin) - 0)/(amin - (-PI/2))*(alpha - (-PI/2)) + 0
		Cm = (Cma*amin - 0)/(amin - (-PI/2))*(alpha - (-PI/2)) + 0
	elif alpha < amax:
		CL = CL0 + CLa*alpha
		Cm = Cma*alpha
	elif alpha < PI/2:
		CL = (0 - (CL0 + CLa*amax))/(PI/2 - amax)*(alpha - amax) + (CL0 + CLa*amax)
		Cm = (0 - (Cm*amax))/(PI/2 - amax)*(alpha - amax) + (Cm*amax)
	else:
		CL = 0
	
	CD = CD0 + CL*CL/(PI*oswald*RA)
	Cm += Cmd*elevator
	if vel.length() > 0:
		Cm +=  Cmq*q*lref/(2.0*vel.length())
	var CX =  CL*sin(alpha) - CD*cos(alpha)
	var CZ = -CL*cos(alpha) - CD*sin(alpha)
	var Fx = thrust*trate + CX*sref*Q
	var Fz = CZ*sref*Q
	My = Cm*lref*sref*Q
	var Mz_screen = -My
	
	var F_screen = Vector2()
	F_screen.x = Fx*cos(theta) - Fz*sin(theta)
	F_screen.y = Fx*sin(theta) + Fz*cos(theta)
	Fx_screen = F_screen.x
	Fy_screen = F_screen.y
	
	mass = 10.36 # kg
	inertia = 1.4 # kg-m2
	linear_damp = 0
	angular_damp = 0
	#mass = 1 
	
	#print ("vel_screen ", vel_screen, " vel ", vel ," alpha_deg ", alpha_deg, " Fx ", Fx, " Fz ", Fz, " F_screen ", F_screen, " theta_deg ", theta_deg, " q ", q, " Mz_screen ", Mz_screen, " dive_deg ", dive*180/PI)

	# Add forces and torque
	#applied_force = F_screen*10
	#applied_torque = Mz_screen
	
	#applied_force = Vector2(0,-mass*98)
	
	#add_torque(My)
