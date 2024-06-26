extends CanvasLayer

onready var cursor: KinematicBody = $"../Cursor"

onready var file_container: VBoxContainer = $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/MarginContainer/LevelsList
onready var line_edit: LineEdit = $MarginContainer/ColorRect/VBoxContainer/MarginContainer/LineEdit
onready var close: Button = $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/ButtonClose
onready var level: Spatial = $"../Level"

var resource_path: String = "user://levels/"

#const encryption: String = "2C@R7$L0T$"
const file_type: String = "." + "tscn"

var selected_level: String = ""

func _ready() -> void:
	populate_file_container(resource_path)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		if !is_visible():
			set_visible(true)
			get_tree().paused = true
			close.grab_focus()
			if $"../CanvasLayer2".is_visible():
				$"../CanvasLayer2".set_visible(false)

func _on_ButtonSave_button_down() -> void:
	if line_edit.get_text().length() > 0:
		var saved = TempControl.create_packed(level.get_child(0))
		var err = ResourceSaver.save(resource_path + line_edit.get_text() + file_type, saved)
		if err != OK:
			printerr("The resource " + line_edit.get_text() + " failed to save!")
	populate_file_container(resource_path)

func _on_ButtonClear_button_down():
	var blank = Spatial.new()
	level.get_child(0).queue_free()
	blank.set_name("Blank")
	level.add_child(blank)
	cursor.reset()

func _on_ButtonClose_button_up():
		set_visible(false)
		get_tree().paused = false

func _on_ButtonLoad_button_down() -> void:
	if selected_level != "":
		var scene = ResourceLoader.load(resource_path + selected_level + file_type)
		scene.set_name("Custom")
		level.add_child(scene.instance())
		cursor.reset()

func _on_File_selected(path, button) -> void:
	selected_level = button.get_text()

func populate_file_container(path: String) -> void:
	var resources = get_files(path, true, true)
	for n in file_container.get_children():
		n.queue_free()
	for i in resources:
		var button = Button.new()
		var file_name = i.get_file()
		file_name.erase(file_name.length() - file_type.length(), file_type.length())
		button.set_text(file_name)
		file_container.add_child(button)
		button.connect("pressed", self, "_on_File_selected", [i, button])

func get_files(folder_path: String, path: bool = false, recursive: bool = true) -> Array:
	var dir := Directory.new()
	if !dir.dir_exists(resource_path):
		dir.make_dir(resource_path)
	if dir.open(folder_path) != OK:
		printerr("Could not open directory: ", folder_path)
		return []
	if dir.list_dir_begin(true, true) != OK:
		printerr("Could not list contents of: ", folder_path)
		return []
	var files := []
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.get_extension() != ".import":
			if dir.current_is_dir():
				if recursive:
					var dir_path = dir.get_current_dir() + "/" + file_name
					files += get_files(dir_path, recursive)
			else:
				var file_path = dir.get_current_dir() + "/" + file_name
				if path:
					files.append(file_path)
				else:
					var file := File.new()
					if file.open(file_path, File.READ) == OK:
						files.append(file)
					else:
						printerr("Could not open file: ", file_path)
			file_name = dir.get_next()
	return files
