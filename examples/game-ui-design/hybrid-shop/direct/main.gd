extends Control

const SCREENS := ["shop"]
var current_screen: Control
var screen_id := "shop"
var capture_dir := ""
var test_mode := false
var test_filter := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--screen="):
			screen_id = argument.trim_prefix("--screen=")
		elif argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
		elif argument == "--test":
			test_mode = true
		elif argument.begins_with("--only="):
			test_filter = argument.trim_prefix("--only=")
	show_screen(screen_id)
	if test_mode:
		await get_tree().process_frame
		var runner = load("res://tests/run_tests.gd").new()
		await runner.run(self)
	elif not capture_dir.is_empty():
		var dimensions := get_viewport_rect().size
		await capture(screen_id + "-%dx%d" % [dimensions.x, dimensions.y])
		get_tree().quit()

func show_screen(id: String) -> void:
	get_tree().paused = false
	if is_instance_valid(current_screen):
		remove_child(current_screen)
		current_screen.queue_free()
	assert(id in SCREENS, "Unknown screen: " + id)
	var source = load("res://screens/" + id + ".gd")
	assert(source != null, "Screen source could not load: " + id)
	current_screen = source.new()
	current_screen.name = id.capitalize()
	add_child(current_screen)
	current_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen_id = id
	DisplayServer.window_set_title("Moonroot Apothecary | " + id.capitalize() + " | direct")

func capture(label: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	assert(image != null and not image.is_empty(), "Renderer did not return an image")
	var directory := capture_dir
	if directory.is_empty():
		directory = ProjectSettings.globalize_path("res://evidence")
	DirAccess.make_dir_recursive_absolute(directory)
	var path := directory.path_join(label + ".png")
	assert(image.save_png(path) == OK, "Could not save capture: " + path)
	print("CAPTURE ", path)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var index := int(event.keycode) - KEY_F1
		if index >= 0 and index < SCREENS.size():
			show_screen(SCREENS[index])
			get_viewport().set_input_as_handled()
