extends CharacterBody2D

signal hit

var direction = Vector2(6000, 0)
var speed: 
	set(new_speed):
		speed = new_speed
		

var start_position
var first_call = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
func _ready():
	#start_position = global_position
	#print(start_position)
	pass

func set_speed(speedin):
	speed = speedin

func _physics_process(delta):
	#var collision_info = move_and_collide(speed.normalized() * delta * 3000 + speed * delta)
	if first_call:
		start_position = global_position
		first_call = false
	var collision_info = move_and_collide(speed * delta + 75*Vector2(cos(rotation), sin(rotation)))
	if collision_info != null:
		var body = collision_info.get_collider()
		if body.name == "Smokestack":
			body._on_hit()
		print("Collided with: ", body.name)
		hit.emit()
		queue_free()
	var dist_traveled = global_position-start_position
	if dist_traveled.length() > 30000:
		queue_free()
	
