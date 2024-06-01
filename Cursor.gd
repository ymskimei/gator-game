extends KinematicBody

var grid_size: int = 2

onready var tween: Tween = $Tween

var up_timer: Timer = Timer.new()
var left_timer: Timer = Timer.new()
var right_timer: Timer = Timer.new()
var down_timer: Timer = Timer.new()

func _ready() -> void:
	up_timer.set_wait_time(0.5)
	up_timer.connect("timeout", self, "_on_timeout_up")
	add_child(up_timer)
	left_timer.set_wait_time(0.5)
	left_timer.connect("timeout", self, "_on_timeout_left")
	add_child(left_timer)
	right_timer.set_wait_time(0.5)
	right_timer.connect("timeout", self, "_on_timeout_right")
	add_child(right_timer)
	down_timer.set_wait_time(0.5)
	down_timer.connect("timeout", self, "_on_timeout_up")
	add_child(down_timer)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("joy_up"):
		tween_position(true, false)
		up_timer.start()
	if Input.is_action_just_released("joy_up"):
		up_timer.stop()
	if Input.is_action_just_pressed("joy_left"):
		tween_position(false, true)
		left_timer.start()
	if Input.is_action_just_released("joy_left"):
		left_timer.stop()
	if Input.is_action_just_pressed("joy_right"):
		tween_position(false, false)
		right_timer.start()
	if Input.is_action_just_released("joy_right"):
		right_timer.stop()
	if Input.is_action_just_pressed("joy_down"):
		tween_position(true, true)
		down_timer.start()
	if Input.is_action_just_released("joy_down"):
		down_timer.stop()

func _on_timeout_up() -> void:
	tween_position(true, false)

func _on_timeout_left() -> void:
	tween_position(false, true)

func _on_timeout_right() -> void:
	tween_position(false, false)

func _on_timeout_down() -> void:
	tween_position(true, true)

func tween_position(axis_x: bool = false, negative: bool = false) -> void:
	var amount: int = grid_size
	if negative:
		amount = -amount
	if axis_x:
		tween.interpolate_property(self, "global_translation:x", global_translation.x, global_translation.x + amount, 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(self, "global_translation:z", global_translation.z, global_translation.z + amount, 0.3, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	global_translation = Vector3(stepify(global_translation.x, 2), stepify(global_translation.y, 2), stepify(global_translation.z, 2))
	print(global_translation)
