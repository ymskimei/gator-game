extends Node

const image_path: String = "user://screenshots/"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		save_screenshot()

func save_screenshot() -> void:
	var time: String = Time.get_date_string_from_system() + "_" + Time.get_time_string_from_system().replace(":", ".")
	var count: int = 0
	var extension: String = ".png"
	var dir = Directory.new()
	if !dir.dir_exists(image_path):
		dir.make_dir(image_path)
	var image = get_screenshot()
	image.save_png(image_path + time + extension)

func get_screenshot() -> Image:
	var screen: Texture = get_viewport().get_texture()
	var image: Image = screen.get_data()
	image.flip_y()
	return image
