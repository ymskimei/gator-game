extends SpringArm

onready var cam: Camera = $Camera
onready var tween: Tween = $Tween

export var rotation_speed: int = 10
export var offset: Vector3 = Vector3(0, 1, 0)
export var follow_speed: float = 3.5
export var height: int = 3
export var zoom: int = 1

var rotation_timer_right: Timer = Timer.new()
var rotation_timer_left: Timer = Timer.new()

func _ready() -> void:
	rotation_timer_right.set_wait_time(0.5)
	rotation_timer_right.connect("timeout", self, "_on_timeout_right")
	add_child(rotation_timer_right)

	rotation_timer_left.set_wait_time(0.5)
	rotation_timer_left.connect("timeout", self, "_on_timeout_left")
	add_child(rotation_timer_left)

	tween.interpolate_property(self, "rotation:y", rotation.y, stepify(rotation.y, deg2rad(45)), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _physics_process(delta: float) -> void:
	translation = lerp(translation, $"../Cursor".translation + offset, follow_speed * delta)

	if Input.is_action_just_pressed("cam_up"):
		if height <= 3:
			height += 1
			tween_height()
	if Input.is_action_just_pressed("cam_down"):
		if height >= 1:
			height -= 1
			tween_height()

	if Input.is_action_just_pressed("cam_right"):
		tween_isometric(45)
		rotation_timer_right.start()
	if Input.is_action_just_released("cam_right"):
		rotation_timer_right.stop()

	if Input.is_action_just_pressed("cam_left"):
		tween_isometric(-45)
		rotation_timer_left.start()
	if Input.is_action_just_released("cam_left"):
		rotation_timer_left.stop()

	if Input.is_action_just_pressed("action_shoulder"):
		if zoom < 2:
			zoom += 1
		else:
			zoom = 0
		tween_zoom()

func _on_timeout_right() -> void:
	tween_isometric(45)
	
func _on_timeout_left() -> void:
	tween_isometric(-45)

func tween_isometric(direction: int) -> void:
	tween.interpolate_property(self, "rotation:y", rotation.y, rotation.y + deg2rad(direction), 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()

func tween_height() -> void:
	var angle: int = -45
	match height:
		4: angle = -90
		3: angle = -45
		2: angle = 0
		1: angle = 45
		0: angle = 90
	tween.interpolate_property(self, "rotation:x", rotation.x, deg2rad(angle), 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()

func tween_zoom() -> void:
	var fov: int = 45
	match zoom:
		2: fov = 40
		1: fov = 55
		0: fov = 70
	tween.interpolate_property(cam, "fov", cam.fov, fov, 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
