extends StateMain

var can_jump: bool = false
var jump_timer: Timer = Timer.new()
var stored_direction: Vector3 = Vector3.ZERO

func enter() -> void:
	can_jump = false
	
	entity.fall_momentum = 1
	stored_direction = get_input()

	jump_timer = Timer.new()
	jump_timer.set_wait_time(0.15)
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "_on_jump_timeout")
	add_child(jump_timer)
	jump_timer.start()

func physics_process(delta: float) -> int:
	set_rotation(delta)

	if !can_jump:
		entity.fall_momentum -= 4 * delta
	if entity.fall_momentum <= -0.5:
		return State.FALL

	stored_direction = stored_direction.bounce(get_surface_normal(true).normalized())
	entity.move_and_collide(stored_direction * 0.1)
	entity.move_and_collide((Vector3.UP * 0.5 * entity.fall_momentum))

	return State.NULL

func _on_jump_timeout() -> void:
	can_jump = false

func exit() -> void:
	entity.can_turn = false

	stored_direction = Vector3.ZERO

	jump_timer.queue_free()
