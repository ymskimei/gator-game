extends StateMain

var jump_combo_timer: Timer = Timer.new()

func enter() -> void:
	entity.move_momentum = 0
	entity.boosting = false

	jump_combo_timer = Timer.new()
	jump_combo_timer.set_wait_time(2)
	jump_combo_timer.one_shot = true
	jump_combo_timer.connect("timeout", self, "_on_jump_combo_timeout")
	add_child(jump_combo_timer)
	jump_combo_timer.start()

func unhandled_input(event: InputEvent) -> int:
	if event.is_action_pressed("action") and is_on_surface():
		return State.JUMP

	return State.NULL

func physics_process(delta: float) -> int:
	set_gravity(delta)
	set_movement(delta)
	set_rotation(delta)

	if entity.direction != Vector3.ZERO:
		return State.MOVE

	if entity.jump_in_memory:
		return State.JUMP

	if !is_on_surface(true):
		return State.FALL

	return State.NULL

func _on_jump_combo_timeout():
#	if entity.jump_level >= 1:
#		entity.jump_level -= 1
#		jump_combo_timer.start()
	pass

func exit() -> void:
	pass
