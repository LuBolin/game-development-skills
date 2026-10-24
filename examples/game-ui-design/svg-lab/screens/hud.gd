extends Control

const ENERGY_COST := 25
const MINT := Color("8feacb")
var energy := 60
var ability_uses := 0
var energy_bar: ProgressBar
var energy_value: Label
var ability_button: Button
var ability_status: Label
var uplink_marker: VBoxContainer
var pulse_flash := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Bahnschrift", "Segoe UI"])
	var ui_theme := Theme.new()
	ui_theme.default_font = font
	ui_theme.default_font_size = 14
	theme = ui_theme
	resized.connect(_resize_hud)
	_build_objective()
	_build_vitals()
	_build_ability()
	var marker := VBoxContainer.new()
	uplink_marker = marker
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	marker.position = Vector2(-60, 197)
	marker.size = Vector2(120, 38)
	marker.add_theme_constant_override("separation", 2)
	add_child(marker)
	var marker_title := _label("UPLINK", 12, MINT)
	marker_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.add_child(marker_title)
	var marker_distance := _label("64 m", 16)
	marker_distance.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.add_child(marker_distance)
	_resize_hud()
	_update_ability()
	ability_button.grab_focus()

func _resize_hud() -> void:
	if is_instance_valid(uplink_marker):
		uplink_marker.position.y = 197 * maxf(size.x / 1280.0, size.y / 720.0)
	queue_redraw()

func _label(text: String, font_size: int, color := Color("e8f2ec")) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label

func _style(fill: Color, border: Color, width := 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(width)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

func _build_objective() -> void:
	var objective := VBoxContainer.new()
	objective.position = Vector2(48, 34)
	objective.add_theme_constant_override("separation", 4)
	objective.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(objective)
	objective.add_child(_label("OUTPOST 07", 12, MINT))
	objective.add_child(_label("Breach the relay", 22))
	objective.add_child(_label("Reach the uplink", 14, Color("9fb5ae")))

func _build_vitals() -> void:
	var panel := PanelContainer.new()
	panel.name = "Vitals"
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.offset_left = 32
	panel.offset_right = 326
	panel.offset_top = -146
	panel.offset_bottom = -32
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel_style := _style(Color("101f24f0"), Color("36524f"))
	panel_style.content_margin_top = 10
	panel_style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", panel_style)
	add_child(panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 4)
	panel.add_child(stack)
	var callsign := _label("VESPER / 04", 14, MINT)
	callsign.custom_minimum_size.y = 20
	stack.add_child(callsign)
	_add_resource(stack, "HEALTH", 86, Color("b3dfb3"))
	energy_bar = _add_resource(stack, "ENERGY", energy, MINT)
	energy_value = stack.get_child(3).get_child(1) as Label
	var rail := ColorRect.new()
	rail.color = MINT
	rail.anchor_top = 1.0
	rail.anchor_bottom = 1.0
	rail.offset_left = 32
	rail.offset_right = 35
	rail.offset_top = -146
	rail.offset_bottom = -32
	rail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(rail)

func _add_resource(stack: VBoxContainer, title: String, value: int, color: Color) -> ProgressBar:
	var row := HBoxContainer.new()
	row.custom_minimum_size.y = 23
	stack.add_child(row)
	var caption := _label(title, 14, Color("9fb5ae"))
	caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(caption)
	row.add_child(_label("%d / 100" % value, 14))
	var bar := ProgressBar.new()
	bar.custom_minimum_size.y = 6
	bar.show_percentage = false
	bar.value = value
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var track := StyleBoxFlat.new()
	track.bg_color = Color("293c3d")
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	bar.add_theme_stylebox_override("background", track)
	bar.add_theme_stylebox_override("fill", fill)
	stack.add_child(bar)
	return bar

func _build_ability() -> void:
	var stack := VBoxContainer.new()
	stack.anchor_left = 1.0
	stack.anchor_right = 1.0
	stack.anchor_top = 1.0
	stack.anchor_bottom = 1.0
	stack.offset_left = -262
	stack.offset_right = -32
	stack.offset_top = -122
	stack.offset_bottom = -32
	stack.add_theme_constant_override("separation", 10)
	add_child(stack)
	ability_button = Button.new()
	ability_button.name = "AbilityButton"
	ability_button.custom_minimum_size = Vector2(230, 58)
	ability_button.text = "Q    PULSE       25 E"
	ability_button.add_theme_font_size_override("font_size", 18)
	ability_button.add_theme_color_override("font_color", Color("e8f2ec"))
	ability_button.add_theme_color_override("font_disabled_color", Color("a7b2ad"))
	ability_button.add_theme_stylebox_override("normal", _style(Color("183f40"), MINT, 2))
	ability_button.add_theme_stylebox_override("hover", _style(Color("245956"), MINT, 2))
	ability_button.add_theme_stylebox_override("pressed", _style(Color("317568"), Color.WHITE, 2))
	ability_button.add_theme_stylebox_override("disabled", _style(Color("203035"), Color("65756c"), 1))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = Color("e9f9d7")
	focus.set_border_width_all(1)
	focus.expand_margin_left = 4
	focus.expand_margin_right = 4
	focus.expand_margin_top = 4
	focus.expand_margin_bottom = 4
	ability_button.add_theme_stylebox_override("focus", focus)
	var key := InputEventKey.new()
	key.physical_keycode = KEY_Q
	ability_button.shortcut = Shortcut.new()
	ability_button.shortcut.events = [key]
	ability_button.pressed.connect(_use_pulse)
	stack.add_child(ability_button)
	ability_status = _label("Disrupt nearby drones", 14, Color("9fb5ae"))
	ability_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stack.add_child(ability_status)

func _use_pulse() -> void:
	if energy < ENERGY_COST:
		return
	energy -= ENERGY_COST
	ability_uses += 1
	pulse_flash = 1.0
	_update_ability()
	queue_redraw()

func _update_ability() -> void:
	energy_value.text = "%d / 100" % energy
	energy_bar.value = energy
	ability_button.disabled = energy < ENERGY_COST
	if ability_button.disabled:
		ability_status.text = "LOW ENERGY / NEED 25"
		ability_status.add_theme_color_override("font_color", Color("e8bb91"))
	elif ability_uses > 0:
		ability_status.text = "Pulse released"
	else:
		ability_status.text = "Disrupt nearby drones"

func get_test_state() -> Dictionary:
	return {"energy": energy, "ability_uses": ability_uses}

func _process(delta: float) -> void:
	if pulse_flash > 0:
		pulse_flash = maxf(0.0, pulse_flash - delta * 2.0)
		queue_redraw()

func _polygon(points: Array, fill: String, outline := "") -> void:
	var vertices := PackedVector2Array()
	for point: Vector2 in points:
		vertices.append(point)
	draw_colored_polygon(vertices, Color(fill))
	if not outline.is_empty():
		vertices.append(vertices[0])
		draw_polyline(vertices, Color(outline), 2, true)

func _draw() -> void:
	# Decorative dummy world is separate from native HUD controls.
	var world_scale := maxf(size.x / 1280.0, size.y / 720.0)
	var world_offset := (size - Vector2(1280,720) * world_scale) / 2.0
	draw_set_transform(world_offset, 0.0, Vector2.ONE * world_scale)
	draw_rect(Rect2(0, 0, 1280, 720), Color("1c3036"))
	draw_circle(Vector2(965, 154), 47, Color("62766c"))
	_polygon([Vector2(0,265),Vector2(128,189),Vector2(243,279),Vector2(370,224),Vector2(470,298),Vector2(637,230),Vector2(807,292),Vector2(948,214),Vector2(1130,271),Vector2(1280,200),Vector2(1280,430),Vector2(0,430)], "2a4143")
	_polygon([Vector2(0,334),Vector2(195,287),Vector2(360,343),Vector2(549,292),Vector2(716,339),Vector2(892,297),Vector2(1087,346),Vector2(1280,285),Vector2(1280,453),Vector2(0,453)], "36524f")
	draw_rect(Rect2(0,369,1280,351), Color("263d3d"))
	_polygon([Vector2(464,720),Vector2(588,369),Vector2(691,369),Vector2(825,720)], "42605a")
	_polygon([Vector2(489,720),Vector2(603,369),Vector2(612,369),Vector2(517,720)], "779785")
	_polygon([Vector2(772,720),Vector2(671,369),Vector2(679,369),Vector2(801,720)], "779785")
	for line: Vector4 in [Vector4(547,568,737,568),Vector4(574,475,708,475),Vector4(589,419,690,419)]:
		draw_line(Vector2(line.x,line.y),Vector2(line.z,line.w),Color("5a786b"),2,true)
	_polygon([Vector2(0,332),Vector2(167,309),Vector2(231,349),Vector2(231,487),Vector2(0,538)], "172d32", "48635d")
	_polygon([Vector2(57,236),Vector2(167,229),Vector2(167,309),Vector2(57,325)], "172d32", "48635d")
	_polygon([Vector2(1028,298),Vector2(1280,339),Vector2(1280,554),Vector2(1005,460)], "172d32", "48635d")
	_polygon([Vector2(1099,217),Vector2(1211,239),Vector2(1211,326),Vector2(1099,308)], "172d32", "48635d")
	_polygon([Vector2(27,356),Vector2(161,341),Vector2(161,348),Vector2(27,365)], "87d5bb")
	_polygon([Vector2(1047,329),Vector2(1243,361),Vector2(1243,368),Vector2(1047,337)], "87d5bb")
	draw_rect(Rect2(1130,261,49,4), Color("87d5bb"))
	_polygon([Vector2(608,269),Vector2(641,252),Vector2(675,269),Vector2(675,377),Vector2(608,377)], "132c31", "628d77")
	draw_line(Vector2(641,252),Vector2(641,377),Color("4a7965"),2,true)
	draw_polyline(PackedVector2Array([Vector2(608,294),Vector2(641,308),Vector2(675,294)]),Color("4a7965"),2,true)
	draw_rect(Rect2(635,277,12,49),Color("a3e9bc"))
	draw_polyline(PackedVector2Array([Vector2(631,243),Vector2(641,234),Vector2(651,243)]),Color("a3e9bc"),2,true)
	_polygon([Vector2(745,368),Vector2(764,359),Vector2(782,368),Vector2(764,380)], "15272d", "e69a76")
	draw_line(Vector2(733,366),Vector2(748,366),Color("e69a76"),3,true)
	draw_line(Vector2(779,366),Vector2(795,366),Color("e69a76"),3,true)
	draw_circle(Vector2(764,370),3,Color("f5ac82"))
	draw_set_transform(world_offset + Vector2(625,548) * world_scale,0.0,Vector2(1,0.3) * world_scale)
	draw_circle(Vector2.ZERO,33,Color("1b3033"))
	draw_set_transform(world_offset,0.0,Vector2.ONE * world_scale)
	_polygon([Vector2(615,500),Vector2(632,499),Vector2(638,527),Vector2(628,541),Vector2(616,531),Vector2(606,522)], "14282e", "89bda9")
	draw_circle(Vector2(625,491),9,Color("1b333a"))
	draw_arc(Vector2(625,491),9,0,TAU,32,Color("89bda9"),2,true)
	draw_polyline(PackedVector2Array([Vector2(632,506),Vector2(648,516),Vector2(663,509)]),Color("15282f"),8,true)
	draw_line(Vector2(619,535),Vector2(612,555),Color("15282f"),8,true)
	draw_line(Vector2(630,536),Vector2(636,554),Color("15282f"),8,true)
	draw_line(Vector2(617,506),Vector2(623,523),MINT,3,true)
	if pulse_flash > 0:
		draw_arc(Vector2(625,530),50 + (1.0-pulse_flash)*70,0,TAU,64,Color(0.56,0.92,0.8,pulse_flash),2,true)
	draw_set_transform(Vector2.ZERO)
	draw_line(Vector2(32,28),Vector2(32,83),MINT,3)
	var center := size / 2.0
	for direction: Vector2 in [Vector2(-1,-1),Vector2(1,-1),Vector2(1,1),Vector2(-1,1)]:
		var corner := center + direction * 13
		draw_line(corner,corner-Vector2(direction.x*5,0),Color("c9e1d3a0"),1,true)
		draw_line(corner,corner-Vector2(0,direction.y*5),Color("c9e1d3a0"),1,true)
