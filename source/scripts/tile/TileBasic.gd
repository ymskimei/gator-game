extends StaticBody

var rotating_x: bool = false
var rotating_y: bool = false
var rotating_z: bool = false

var rotation_speed: float = 0.0

func _ready() -> void:
	rotation_speed = 0.0

func _physics_process(delta: float) -> void:
	var rotations: Vector3 = Vector3.ZERO
	if rotating_x:
		rotations.x = rotation_speed * 2
	else:
		rotations.x = 0
	if rotating_y:
		rotations.y = rotation_speed * 2
	else:
		rotations.y = 0
	if rotating_z:
		rotations.z = rotation_speed * 2
	else:
		rotations.z = 0
	if rotating_x or rotating_y or rotating_z:
		rotation_degrees += rotations * delta
	elif rotation_degrees != Vector3.ZERO:
		rotation_degrees = Vector3.ZERO
