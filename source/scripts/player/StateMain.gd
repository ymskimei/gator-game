class_name StateMain
extends Node

var entity: KinematicBody = null

enum State {
	NULL,
	FALL,
	IDLE,
	MOVE,
	JUMP,
	WJMP,
	GPND,
	SLID
}

func get_surface_normal(raw: bool = false) -> Vector3:
	var surface_normal = Vector3.ZERO
	var norm_avg = Vector3.ZERO
	var rays_colliding := 0
	for ray in entity.surface_rays.get_children():
		var r : RayCast = ray
		if r.is_colliding():
			if !raw:
				if r.get_collision_normal().y == -180 or r.get_collider().is_in_group("sticky"):
					rays_colliding += 1
					norm_avg += r.get_collision_normal()
			else:
				rays_colliding += 1
				norm_avg += r.get_collision_normal()
	if norm_avg:
		surface_normal = norm_avg / rays_colliding
	else:
		surface_normal = Vector3.UP
	return surface_normal

func set_gravity(delta: float) -> void:
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	entity.move_and_slide_with_snap((gravity / 3 + entity.fall_momentum) * -get_surface_normal() * delta, Vector3.DOWN, Vector3.UP, true)
	entity.global_transform.basis.y = get_surface_normal()
	entity.global_transform.basis.x = -entity.global_transform.basis.z.cross(get_surface_normal())
	entity.global_transform.basis = entity.global_transform.basis.orthonormalized()

func get_input(raw: bool = false) -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	direction.x = Input.get_axis("joy_left", "joy_right")
	direction.z = Input.get_axis("joy_up", "joy_down")
	if !raw:
		direction = direction * 2
	direction = direction.rotated(Vector3.UP, Game.camera.rotation.y)
	return direction

func set_movement(delta: float, modifier: float = 1.0, control: bool = true, reverse: bool = false) -> void:
	if control:
		entity.direction = get_input()
	if entity.direction != Vector3.ZERO:
		var movement: Vector3 = (3.75 * modifier * entity.direction * delta)
		if reverse:
			movement = -movement
		entity.move_and_slide(movement * 50 * modifier, Vector3.UP, false, 4, deg2rad(75))

func set_rotation(delta: float, modifier: float = 1.0) -> void:
	if entity.direction != Vector3.ZERO:
		entity.facing = atan2(-entity.direction.x, -entity.direction.z)
	entity.rotation.y = lerp_angle(entity.rotation.y, entity.facing, 12 * modifier * delta)

func is_on_surface(down_only: bool = false) -> bool:
	if entity.surface_rays:
		for ray in entity.surface_rays.get_children():
			var r: RayCast = ray
			if down_only:
				if r.is_colliding() and r.get_collision_normal().y == 1.0 or entity.is_on_floor():
					return true
			elif r.is_colliding():
					return true
	return false
