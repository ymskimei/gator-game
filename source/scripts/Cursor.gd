extends KinematicBody

onready var highlight: MeshInstance = $MeshInstance
onready var cursor: MeshInstance = $MeshInstance/MeshInstance
onready var grid_chunk: Area = $Area
onready var display: Viewport = $CanvasLayer/Viewport
onready var tween: Tween = $Tween

onready var level: Spatial = $"../Level"

export var objects: Array = []

var selection: int = 0
var grid_size: int = 2

var direction: Vector3 = Vector3.ZERO
var can_place: bool = true

var move_timer: Timer = Timer.new()

func _ready() -> void:
	move_timer.set_wait_time(0.25)
	move_timer.connect("timeout", self, "_on_move_timeout")
	add_child(move_timer)
	update_selected_display()

func _unhandled_input(event: InputEvent) -> void:
	#Cycle between tiles array
	if event.is_action_pressed("pad_left") and selection >= 1:
		selection -= 1
		update_selected_display()
	if event.is_action_pressed("pad_right") and selection <= objects.size() - 2:
		selection += 1
		update_selected_display()

	#Place tiles if none are in the way
	if event.is_action_pressed("action") and !tween.is_active():
		if can_place:
			var node = objects[selection].instance()
			level.get_child(0).add_child(node)
			node.set_global_translation(Vector3(stepify(get_global_translation().x, grid_size), stepify(get_global_translation().y, grid_size), stepify(get_global_translation().z, grid_size)))

	#Delete tiles if they are present
	if event.is_action_pressed("action_sub") and !can_place:
		for n in grid_chunk.get_overlapping_bodies():
			n.queue_free()

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("joy_left", "joy_right")
	direction.y = Input.get_axis("trigger_left", "trigger_right")
	direction.z = Input.get_axis("joy_up", "joy_down")

	direction = direction.normalized().rotated(Vector3.UP, $"../SpringArm".rotation.y)
	direction = Vector3(round(direction.x), round(direction.y), round(direction.z))

	#Move cursor position within grid distances
	if Input.is_action_just_pressed("joy_up") or Input.is_action_just_pressed("joy_left") or Input.is_action_just_pressed("joy_right") or Input.is_action_just_pressed("joy_down") or Input.is_action_just_pressed("trigger_left") or Input.is_action_just_pressed("trigger_right") and !tween.is_active():
		tween_position()
		move_timer.start()
	if Input.is_action_just_released("joy_up") or Input.is_action_just_released("joy_left") or Input.is_action_just_released("joy_right") or Input.is_action_just_released("joy_down") or Input.is_action_just_pressed("trigger_left") or Input.is_action_just_pressed("trigger_right"):
		move_timer.stop()

	#Check if placement is possible or if a tile is occupying the space
	if grid_chunk.get_overlapping_bodies().size() >= 1:
		if can_place:
			can_place = false
		highlight.get_surface_material(0).set_shader_param("barrier_color", Color("FF463F"))
		cursor.get_surface_material(0).set_albedo(Color("FF463F"))
	else:
		if !can_place:
			can_place = true
		highlight.get_surface_material(0).set_shader_param("barrier_color", Color("44EF3B"))
		cursor.get_surface_material(0).set_albedo(Color("44EF3B"))

func update_selected_display() -> void:
	#Update corner display of current tile selection for placing
	var display_node = objects[selection].instance()
	for n in display.get_children():
		if n is PhysicsBody:
			n.queue_free()
	display.add_child(display_node)

func _on_move_timeout() -> void:
	tween_position()

func tween_position() -> void:
	var amount: int = grid_size
	tween.interpolate_property(self, "global_translation", global_translation, global_translation + amount * direction, 0.1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	set_global_translation(Vector3(stepify(get_global_translation().x, grid_size), stepify(get_global_translation().y, grid_size), stepify(get_global_translation().z, grid_size)))
