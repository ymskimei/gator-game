extends KinematicBody

export var objects: Array = []
onready var tween: Tween = $Tween
var move_timer: Timer = Timer.new()

var direction: Vector3 = Vector3.ZERO
var grid_size: int = 2
var selection: int = 0

func _ready() -> void:
	move_timer.set_wait_time(0.25)
	move_timer.connect("timeout", self, "_on_move_timeout")
	add_child(move_timer)
	update_selected_display()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pad_left"):
		selection += 1
		update_selected_display()
	if event.is_action_pressed("pad_right") and selection >= 0:
		selection -= 1
		update_selected_display()
	if event.is_action_pressed("action") and !tween.is_active():
		var node = objects[selection].instance()
		node.set_global_transform(get_global_transform())
		$"../Level".add_child(node)

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("joy_left", "joy_right")
	direction.y = Input.get_axis("trigger_left", "trigger_right")
	direction.z = Input.get_axis("joy_up", "joy_down")
	direction = direction.normalized().rotated(Vector3.UP, $"../SpringArm".rotation.y)
	direction = Vector3(round(direction.x), round(direction.y), round(direction.z))
	if Input.is_action_just_pressed("joy_up") or Input.is_action_just_pressed("joy_left") or Input.is_action_just_pressed("joy_right") or Input.is_action_just_pressed("joy_down") or Input.is_action_just_pressed("trigger_left") or Input.is_action_just_pressed("trigger_right") and !tween.is_active():
			tween_position()
			move_timer.start()
	if Input.is_action_just_released("joy_up") or Input.is_action_just_released("joy_left") or Input.is_action_just_released("joy_right") or Input.is_action_just_released("joy_down") or Input.is_action_just_pressed("trigger_left") or Input.is_action_just_pressed("trigger_right"):
		move_timer.stop()

func update_selected_display() -> void:
	var display_node = objects[selection].instance()
	for n in $"../Viewport".get_children():
		if n is PhysicsBody:
			n.queue_free()
	$"../Viewport".add_child(display_node)

func _on_move_timeout() -> void:
	tween_position()

func tween_position() -> void:
	var amount: int = grid_size
	tween.interpolate_property(self, "global_translation", global_translation, global_translation + amount * direction, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	global_translation = Vector3(stepify(global_translation.x, 2), stepify(global_translation.y, 2), stepify(global_translation.z, 2))
	print(global_translation)
