class_name TileStart
extends StaticBody

onready var mesh: MeshInstance = $MeshInstance
onready var collision: CollisionShape = $CollisionShape

func spawn(object):
	var o = object.instance()
	$"../../".add_child(o)
	o.set_global_translation(get_global_translation())

func _physics_process(delta: float):
	if Game.editor_mode:
		set_visible(true)
		collision.set_disabled(false)
	else:
		set_visible(false)
		collision.set_disabled(true)
