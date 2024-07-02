extends CanvasLayer

onready var check_x: CheckBox = $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/CheckX
onready var check_y: CheckBox = $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/CheckY
onready var check_z: CheckBox = $MarginContainer/ColorRect/VBoxContainer/HBoxContainer/CheckZ
onready var rotation_speed: HSlider = $MarginContainer/ColorRect/VBoxContainer/SliderSpeed

onready var cursor: KinematicBody = $"../Cursor"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_menu") and cursor.selected != null and !$"../CanvasLayer".is_visible():
		if !is_visible():
			set_visible(true)
			get_tree().paused = true
			check_x.set_pressed(cursor.selected.rotating_x)
			check_y.set_pressed(cursor.selected.rotating_y)
			check_z.set_pressed(cursor.selected.rotating_z)
			rotation_speed.set_value(cursor.selected.rotation_speed)
			check_x.grab_focus()
		else:
			set_visible(false)
			get_tree().paused = false

func _on_CheckX_toggled(button_pressed):
	if button_pressed:
		cursor.selected.rotating_x = true
	else:
		cursor.selected.rotating_x = false

func _on_CheckY_toggled(button_pressed):
	if button_pressed:
		cursor.selected.rotating_y = true
	else:
		cursor.selected.rotating_y = false

func _on_CheckZ_toggled(button_pressed):
	if button_pressed:
		cursor.selected.rotating_z = true
	else:
		cursor.selected.rotating_z = false

func _on_SliderSpeed_value_changed(value):
	cursor.selected.rotation_speed = value
