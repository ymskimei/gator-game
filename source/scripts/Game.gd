extends Spatial

const sound_dir: String = "res://assets/sound/"

var editor_mode: bool = true
var invert_camera: bool = false

var camera: Spatial = null
var player: Spatial = null
var editor_camera: Spatial = null
var editor_cursor: Spatial = null

func set_camera(node: Spatial):
	camera = node

func set_player(node: Spatial):
	player = node

func set_editor_camera(node: Spatial):
	editor_camera = node

func set_editor_cursor(node: Spatial):
	editor_cursor = node

func play_sfx(file_name: String, pitch: float = 1.0, volume: float = 0.0) -> void:
	var sfx = AudioStreamPlayer.new()
	var sound_effect = get_sound(file_name)
	if sound_effect:
		sfx.stream = sound_effect
		sfx.set_volume_db(-8.0)
		sfx.set_bus("SFX")
		add_child(sfx)
		sfx.set_pitch_scale(pitch)
		sfx.set_volume_db(volume)
		sfx.play()
		yield(sfx, "finished")
		sfx.queue_free()

func play_rand_sfx(file_name_array: Array = [], pitch: float = 1.0, volume: float = 0.0):
	play_sfx(file_name_array[rand_range(0, file_name_array.size())])

func play_pos_sfx(file_name: String, spatial: Vector3 = Vector3.ZERO, pitch: float = 1.0, volume: float = 0.0) -> void:
	var sfx = AudioStreamPlayer3D.new()
	var sound_effect = get_sound(file_name)
	if sound_effect:
		sfx.stream = sound_effect
		sfx.set_unit_db(8.0)
		sfx.set_attenuation_filter_db(-16.0)
		sfx.set_attenuation_filter_cutoff_hz(16000.0)
		sfx.set_bus("SFX")
		add_child(sfx)
		sfx.global_translation = spatial
		sfx.pitch_scale = pitch
		sfx.unit_db = volume
		sfx.play()
		yield(sfx, "finished")
		sfx.queue_free()

func get_sound(file_name: String) -> AudioStreamOGGVorbis:
	var full_path = sound_dir + file_name + ".ogg"
	var file = File.new()
	var ogg = AudioStreamOGGVorbis.new()
	file.open(full_path, File.READ)
	ogg.data = file.get_buffer(file.get_len())
	file.close()
	return ogg
