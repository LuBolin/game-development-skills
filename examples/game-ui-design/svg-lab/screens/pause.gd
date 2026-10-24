extends Control

var settings_open := false
var menu: VBoxContainer
var settings: VBoxContainer
var resume_button: Button
var settings_button: Button
var back_button: Button
var volume_slider: HSlider
var volume_label: Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	# The desktop defaults leave controller confirm and cancel unbound.
	for binding in [["ui_accept", JOY_BUTTON_A], ["ui_cancel", JOY_BUTTON_B]]:
		var event := InputEventJoypadButton.new()
		event.button_index = binding[1]
		if not InputMap.action_has_event(binding[0], event):
			InputMap.action_add_event(binding[0], event)
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Bahnschrift", "Arial"])
	var ui_theme := Theme.new()
	ui_theme.default_font = font
	ui_theme.default_font_size = 22
	ui_theme.set_color("font_color", "Label", Color("e8eee8"))
	for state in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color"]:
		ui_theme.set_color(state, "Button", Color("e8eee8"))
	ui_theme.set_stylebox("normal", "Button", _button_style(Color.TRANSPARENT))
	ui_theme.set_stylebox("hover", "Button", _button_style(Color(1, 1, 1, 0.05)))
	ui_theme.set_stylebox("pressed", "Button", _button_style(Color(0.86, 0.74, 0.47, 0.12)))
	ui_theme.set_stylebox("focus", "Button", _focus_style())
	theme = ui_theme
	menu = _column("PauseMenu")
	_header(menu, "PAUSED")
	resume_button = _button(menu, "ResumeButton", "Resume")
	resume_button.pressed.connect(_resume)
	_space(menu, 12)
	settings_button = _button(menu, "SettingsButton", "Settings")
	settings_button.pressed.connect(_open_settings)
	_space(menu, 36)
	var rule := ColorRect.new()
	rule.color = Color("445b50")
	rule.custom_minimum_size = Vector2(40, 1)
	rule.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu.add_child(rule)
	settings = _column("SettingsMenu")
	_header(settings, "SETTINGS")
	var volume_row := HBoxContainer.new()
	volume_row.custom_minimum_size = Vector2(260, 26)
	volume_row.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	settings.add_child(volume_row)
	var volume_title := _label("Volume", 18)
	volume_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	volume_row.add_child(volume_title)
	volume_label = _label("72%", 18)
	volume_label.add_theme_color_override("font_color", Color("dbbd79"))
	volume_row.add_child(volume_label)
	_space(settings, 12)
	volume_slider = HSlider.new()
	volume_slider.name = "VolumeSlider"
	volume_slider.custom_minimum_size = Vector2(260, 32)
	volume_slider.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.step = 1
	volume_slider.value = 72
	volume_slider.value_changed.connect(_set_volume)
	settings.add_child(volume_slider)
	var volume_focus := Panel.new()
	volume_focus.mouse_filter = Control.MOUSE_FILTER_IGNORE
	volume_focus.add_theme_stylebox_override("panel", _focus_style())
	volume_slider.add_child(volume_focus)
	volume_focus.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	volume_focus.hide()
	volume_slider.focus_entered.connect(volume_focus.show)
	volume_slider.focus_exited.connect(volume_focus.hide)
	_space(settings, 30)
	back_button = _button(settings, "BackButton", "Back")
	back_button.custom_minimum_size.x = 150
	back_button.pressed.connect(_back)
	_link_focus(resume_button, settings_button)
	_link_focus(volume_slider, back_button)
	settings.hide()
	_set_volume(volume_slider.value)
	get_tree().paused = true
	resume_button.grab_focus()
	resized.connect(queue_redraw)

func _column(node_name: String) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.name = node_name
	column.add_theme_constant_override("separation", 0)
	add_child(column)
	column.anchor_top = 0.5
	column.anchor_bottom = 0.5
	column.offset_left = 80
	column.offset_right = 380
	column.offset_top = -140
	column.offset_bottom = 140
	return column

func _header(column: VBoxContainer, title: String) -> void:
	var context := _label("NORTH RIDGE / 06", 13)
	var mono := SystemFont.new()
	mono.font_names = PackedStringArray(["Consolas", "Courier New"])
	context.add_theme_font_override("font", mono)
	context.add_theme_color_override("font_color", Color("8da69c"))
	context.custom_minimum_size.y = 16
	column.add_child(context)
	_space(column, 12)
	var heading := _label(title, 56)
	var heavy := SystemFont.new()
	heavy.font_names = PackedStringArray(["Bahnschrift", "Arial"])
	heavy.font_weight = 600
	heading.add_theme_font_override("font", heavy)
	heading.custom_minimum_size.y = 68
	column.add_child(heading)
	_space(column, 28)

func _label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	return label

func _space(column: VBoxContainer, height: float) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size.y = height
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(spacer)

func _button(column: VBoxContainer, node_name: String, text: String) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(224, 50)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	column.add_child(button)
	return button

func _button_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.content_margin_left = 20
	style.content_margin_right = 20
	return style

func _focus_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.03)
	style.border_color = Color("dbbd79")
	style.set_border_width_all(2)
	return style

func _link_focus(first: Control, second: Control) -> void:
	first.focus_neighbor_bottom = first.get_path_to(second)
	first.focus_neighbor_top = first.get_path_to(second)
	first.focus_next = first.get_path_to(second)
	first.focus_previous = first.get_path_to(second)
	second.focus_neighbor_bottom = second.get_path_to(first)
	second.focus_neighbor_top = second.get_path_to(first)
	second.focus_next = second.get_path_to(first)
	second.focus_previous = second.get_path_to(first)

func _open_settings() -> void:
	settings_open = true
	menu.hide()
	settings.show()
	volume_slider.grab_focus()

func _back() -> void:
	settings_open = false
	settings.hide()
	menu.show()
	settings_button.grab_focus()

func _resume() -> void:
	get_tree().paused = false
	settings_open = false
	menu.hide()
	settings.hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _set_volume(value: float) -> void:
	volume_label.text = "%d%%" % int(value)
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(value / 100.0, 0.0001)))
	AudioServer.set_bus_mute(0, value <= 0)

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused and event.is_action_pressed("ui_cancel"):
		if settings_open:
			_back()
		else:
			_resume()
		get_viewport().set_input_as_handled()

func get_test_state() -> Dictionary:
	return {"paused": get_tree().paused, "settings_open": settings_open, "volume": volume_slider.value}

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, size / Vector2(1280, 720))
	draw_rect(Rect2(0, 0, 1280, 720), Color("172d29"))
	_poly([Vector2(430, 720), Vector2(846, 0), Vector2(1044, 0), Vector2(620, 720)], Color("35443b"))
	draw_line(Vector2(476, 720), Vector2(891, 0), Color("596052", 0.45), 2)
	draw_line(Vector2(578, 720), Vector2(995, 0), Color("596052", 0.45), 2)
	_poly([Vector2(680, 502), Vector2(1280, 350), Vector2(1280, 456), Vector2(616, 632)], Color("2d3d34"))
	draw_rect(Rect2(824, 174, 298, 217), Color("101f1e"))
	draw_rect(Rect2(837, 160, 274, 214), Color("3d5147"))
	draw_rect(Rect2(855, 178, 238, 178), Color("30433a"))
	for y in [236, 296]:
		draw_line(Vector2(855, y), Vector2(1093, y), Color("4b5c4f"), 2)
	for x in [914, 1034]:
		draw_line(Vector2(x, 178), Vector2(x, 356), Color("4b5c4f"), 2)
	draw_rect(Rect2(948, 356, 50, 18), Color("142724"))
	draw_rect(Rect2(1140, 310, 50, 66), Color("405046"))
	draw_rect(Rect2(1146, 316, 38, 54), Color("2a3c33"))
	draw_polyline(PackedVector2Array([Vector2(786, 121), Vector2(1179, 121), Vector2(1179, 421), Vector2(1125, 421)]), Color("607063", 0.45), 3)
	for x in [803, 932, 1059, 1179]:
		draw_line(Vector2(x, 121), Vector2(x, 86), Color("607063", 0.45), 3)
	for point in [Vector2(678, 90), Vector2(597, 172), Vector2(701, 255), Vector2(531, 317), Vector2(1186, 94), Vector2(1256, 169), Vector2(1196, 572), Vector2(1115, 643), Vector2(971, 662), Vector2(535, 623), Vector2(437, 529), Vector2(341, 163), Vector2(294, 623)]:
		_pine(point)
	draw_circle(Vector2(1007, 489), 70, Color("b48a42", 0.055))
	draw_circle(Vector2(1007, 489), 40, Color("b48a42", 0.08))
	draw_rect(Rect2(986, 472, 42, 34), Color("503f2d"))
	draw_rect(Rect2(995, 479, 24, 21), Color("9c7137"))
	draw_circle(Vector2(779, 480), 22, Color("d4bc77", 0.10))
	_poly([Vector2(767, 479), Vector2(778, 468), Vector2(793, 478), Vector2(787, 493), Vector2(774, 494)], Color("9dafa1"))
	draw_circle(Vector2(783, 470), 6, Color("c0c6ae"))
	draw_line(Vector2(787, 478), Vector2(808, 467), Color("253730"), 5)
	if get_tree().paused:
		draw_rect(Rect2(0, 0, 1280, 720), Color("071512", 0.19))
		draw_rect(Rect2(0, 0, 490, 720), Color("0b1c19", 0.88))
		draw_rect(Rect2(490, 0, 100, 720), Color("0b1c19", 0.38))

func _poly(points: Array, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array(points), color)

func _pine(origin: Vector2) -> void:
	_poly([origin + Vector2(0, -34), origin + Vector2(-22, 8), origin + Vector2(-12, 8), origin + Vector2(-28, 30), origin + Vector2(28, 30), origin + Vector2(12, 8), origin + Vector2(22, 8)], Color("203d36"))
	_poly([origin + Vector2(0, -34), origin + Vector2(0, 30), origin + Vector2(28, 30), origin + Vector2(12, 8), origin + Vector2(22, 8)], Color("28453b"))
