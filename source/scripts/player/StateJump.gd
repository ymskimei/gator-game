
extends StateMain

var jumping: bool = true
var jump_timer: Timer = Timer.new()

func enter() -> void:
	entity.jump_in_memory = false
	entity.fall_momentum = 1

	jumping = true

	jump_timer = Timer.new()
	jump_timer.set_wait_time(0.085)
	jump_timer.one_shot = true
	jump_timer.connect("timeout", self, "_on_jump_timeout")
	add_child(jump_timer)
	jump_timer.start()

func unhandled_input(event: InputEvent) -> int:
	if event.is_action_released("action"):
		jumping = false
	if event.is_action_pressed("action") and is_on_surface() and !is_on_surface(true):
		return State.WJMP

	if event.is_action_pressed("trigger_right"):
			return State.GPND

	return State.NULL

func physics_process(delta: float) -> int:
#	var jump_boost: float = 0.25

	set_movement(delta, 1.15 + (entity.move_momentum * 0.5))
	set_rotation(delta * 0.5)

	#Set jump multiplier by combo (level) of jump
#	match entity.jump_level:
#		0:
#			jump_boost = 0.5
#		1:
#			jump_boost - 0.55
#		2:
#			jump_boost = 0.6

	entity.move_and_collide((Vector3.UP * 0.3) * entity.fall_momentum)

	if !jumping:
		entity.fall_momentum -= 7 * delta
	if entity.fall_momentum <= 0:

	#Add to or reset jump combo
#		if entity.jump_level >= 2:
#			entity.jump_level = 0
#		else:
#			entity.jump_level += 1

		return State.FALL
	return State.NULL

func _on_jump_timeout() -> void:
	jumping = false

func exit() -> void:
	jump_timer.queue_free()
