extends SpringArm

onready var cam: Camera = $Camera

var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	Game.set_camera(self)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	direction.y = Input.get_action_strength("cam_left") - Input.get_action_strength("cam_right")
	direction.x = Input.get_action_strength("cam_up") - Input.get_action_strength("cam_down")

	if Game.invert_camera:
		direction = -direction

	velocity = velocity.linear_interpolate(Vector3(direction.x, direction.y, 0) * 3.15, 20 * delta)

	global_rotation.y += deg2rad(-velocity.y)
	global_rotation.x = clamp(global_rotation.x + deg2rad(-velocity.x), deg2rad(-90), deg2rad(20))
	
	if is_instance_valid(Game.player):
		global_transform.origin = lerp(global_transform.origin, Game.player.global_transform.origin + Vector3(0, 1, 0), 10 * delta)
