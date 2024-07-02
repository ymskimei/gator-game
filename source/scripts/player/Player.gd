extends KinematicBody

onready var model: Spatial = $MeshInstance
onready var collision: CollisionShape = $CollisionShape

onready var surface_rays: Spatial = $SurfaceRays

onready var states: Node = $States

var input: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO

var fall_momentum: float = 0.0
var move_momentum: float = 0.0
var max_momentum: float = 0.5

var facing: float = 0.0
var jump_level: int = 0

var jump_in_memory: bool = false
var can_late_jump: bool = false

var boosting: bool = false
#var temporary_exhaustion: bool = false

var can_jump: bool = false
var can_turn: bool = true
var can_roll: bool = true

func _ready() -> void:
	Game.set_player(self)
	states.ready(self)

func _input(event: InputEvent) -> void:
	if !Game.editor_mode:
		states.input(event)

func _unhandled_input(event: InputEvent) -> void:
	if !Game.editor_mode:
		states.unhandled_input(event)
		if event.is_action_pressed("toggle_menu"):
			Game.editor_camera.cam.make_current()
			Game.editor_mode = true
			queue_free()

func _process(delta: float) -> void:
	if !Game.editor_mode:
		states.process(delta)

func _physics_process(delta: float) -> void:
	if !Game.editor_mode:
		states.physics_process(delta)
		if get_global_translation().y <= -50:
			Game.editor_camera.cam.make_current()
			Game.editor_mode = true
			queue_free()
