extends Position3D

onready var camera: SpringArm = $"../SpringArm"

func _physics_process(delta: float):
	set_global_translation(Vector3(camera.get_global_translation().x, camera.get_global_translation().y - 50, camera.get_global_translation().z))
