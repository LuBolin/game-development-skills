extends Control

const INK := Color("f3e4c5")
const MUTED := Color("b8b49b")
const ITEMS := [
	{"id": "bow", "title": "Mosswood bow", "kind": "RANGED WEAPON", "description": "A steady hand, a silent string.", "stat": "18 attack", "weight": "1.8 kg", "count": ""},
	{"id": "knife", "title": "Ashen knife", "kind": "MELEE WEAPON", "description": "A trusted blade for close company.", "stat": "12 attack", "weight": "0.6 kg", "count": ""},
	{"id": "charm", "title": "Moonleaf talisman of the First Keeper of the Western Hollow", "kind": "WOODLAND CHARM", "description": "The old paths remember their keeper.", "stat": "+8 ward", "weight": "0.2 kg", "count": ""},
	{"id": "potion", "title": "Briar tonic", "kind": "PROVISION", "description": "Bitter roots, a little warmth.", "stat": "Restores 40 health", "weight": "0.3 kg", "count": "4"},
	{"id": "ore", "title": "River iron", "kind": "CRAFTING MATERIAL", "description": "Cold metal from the shallow stream.", "stat": "Used at a forge", "weight": "2.4 kg", "count": "8"}
]
var selected := "bow"
var equipped := "knife"
var is_open := true
var panel: Panel
var grid: GridContainer
var details: Control
var title_label: Label
var kind_label: Label
var description_label: Label
var stat_label: Label
var weight_label: Label
var equipped_label: Label
var detail_icon: TextureRect
var equip_button: Button
var close_button: Button
var open_button: Button
var item_buttons: Array[Button] = []
var count_labels: Array[Label] = []
var icons: Dictionary = {}

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var body_font := SystemFont.new()
	body_font.font_names = PackedStringArray(["Segoe UI", "Arial"])
	var body_theme := Theme.new()
	body_theme.default_font = body_font
	body_theme.default_font_size = 18
	theme = body_theme
	for item in ITEMS:
		icons[item.id] = _icon(item.id)
	panel = Panel.new()
	panel.add_theme_stylebox_override("panel", _style("293329", "9b8e63", 2))
	add_child(panel)
	var heading := _label(panel, "Field satchel", Vector2(34, 20), Vector2(500, 48), 36, INK)
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia", "Times New Roman"])
	heading.add_theme_font_override("font", serif)
	_label(panel, "Provisions for the path ahead", Vector2(35, 70), Vector2(500, 24), 16, MUTED)
	close_button = _button(panel, "×", "CloseButton", Vector2(56, 44))
	close_button.tooltip_text = "Close satchel, Escape"
	close_button.pressed.connect(_close)
	_line(panel, Vector2(34, 106), Vector2(892, 1))
	_label(panel, "CARRIED", Vector2(34, 115), Vector2(220, 26), 16, MUTED)
	var slots := _label(panel, "5 / 12 slots", Vector2(300, 115), Vector2(168, 26), 14, MUTED)
	slots.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	grid = GridContainer.new()
	grid.columns = 4
	grid.position = Vector2(34, 150)
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	panel.add_child(grid)
	for index in range(12):
		if index < ITEMS.size():
			var item: Dictionary = ITEMS[index]
			var button := _button(grid, "", "Item" + str(index), Vector2(98, 94))
			if index == 0:
				button.name = "FirstItemButton"
			elif index == 2:
				button.name = "LongItemButton"
			button.tooltip_text = item.title
			button.pressed.connect(_select.bind(item.id))
			button.focus_entered.connect(_select.bind(item.id))
			item_buttons.append(button)
			var art := TextureRect.new()
			art.texture = icons[item.id]
			art.position = Vector2(17, 10)
			art.size = Vector2(64, 64)
			art.mouse_filter = Control.MOUSE_FILTER_IGNORE
			button.add_child(art)
			var count := _label(button, item.count, Vector2(10, 67), Vector2(78, 20), 14, INK)
			count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			count_labels.append(count)
		else:
			var empty := Panel.new()
			empty.custom_minimum_size = Vector2(98, 94)
			empty.add_theme_stylebox_override("panel", _style("263026", "404b3b"))
			grid.add_child(empty)
			var dot := _label(empty, "·", Vector2(0, 26), Vector2(98, 40), 24, Color("56604b"))
			dot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	details = Control.new()
	panel.add_child(details)
	_line(panel, Vector2(506, 130), Vector2(1, 358))
	kind_label = _label(details, "", Vector2.ZERO, Vector2(350, 22), 16, MUTED)
	detail_icon = TextureRect.new()
	detail_icon.position = Vector2(4, 28)
	detail_icon.size = Vector2(72, 72)
	detail_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	details.add_child(detail_icon)
	title_label = _label(details, "", Vector2(0, 104), Vector2(350, 68), 25, INK)
	title_label.add_theme_font_override("font", serif)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.max_lines_visible = 2
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	description_label = _label(details, "", Vector2(0, 178), Vector2(350, 42), 16, MUTED)
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stat_label = _label(details, "", Vector2(0, 230), Vector2(230, 26), 18, INK)
	weight_label = _label(details, "", Vector2(250, 230), Vector2(100, 26), 16, MUTED)
	_line(details, Vector2(0, 266), Vector2(350, 1))
	equipped_label = _label(details, "", Vector2(0, 278), Vector2(350, 24), 16, MUTED)
	equipped_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	equip_button = _button(details, "Equip", "EquipButton", Vector2(142, 44))
	equip_button.position = Vector2(0, 314)
	equip_button.add_theme_color_override("font_color", Color("1f2b23"))
	equip_button.add_theme_stylebox_override("normal", _style("bb9a60", "ead098"))
	equip_button.add_theme_stylebox_override("hover", _style("d0ae72", "f3ddb1"))
	equip_button.pressed.connect(_equip)
	_line(panel, Vector2(34, 495), Vector2(892, 1))
	_label(panel, "Arrows  Select     Tab  Action     Enter  Confirm", Vector2(34, 512), Vector2(620, 22), 14, MUTED)
	var cancel := _label(panel, "Esc  Close", Vector2(760, 512), Vector2(166, 22), 14, MUTED)
	cancel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	open_button = _button(self, "Open satchel  [I]", "OpenButton", Vector2(196, 48))
	open_button.visible = false
	open_button.pressed.connect(_open)
	for index in range(item_buttons.size()):
		var button: Button = item_buttons[index]
		button.focus_neighbor_left = button.get_path_to(item_buttons[maxi(0, index - 1)])
		button.focus_neighbor_right = button.get_path_to(item_buttons[mini(item_buttons.size() - 1, index + 1)])
		button.focus_neighbor_top = button.get_path_to(item_buttons[maxi(0, index - 4)])
		button.focus_neighbor_bottom = button.get_path_to(item_buttons[mini(item_buttons.size() - 1, index + 4)])
		button.focus_next = button.get_path_to(equip_button)
		button.focus_previous = button.get_path_to(close_button)
	equip_button.focus_next = equip_button.get_path_to(close_button)
	equip_button.focus_previous = equip_button.get_path_to(item_buttons[0])
	close_button.focus_next = close_button.get_path_to(item_buttons[0])
	close_button.focus_previous = close_button.get_path_to(equip_button)
	resized.connect(_layout)
	_layout()
	_select(selected)
	item_buttons[0].grab_focus.call_deferred()

func _layout() -> void:
	if panel == null:
		return
	panel.size = Vector2(minf(960, size.x - 80), 560)
	panel.position = (size - panel.size) / 2.0
	close_button.position = Vector2(panel.size.x - 90, 29)
	details.position = Vector2(540, 130)
	details.size = Vector2(panel.size.x - 574, 358)
	for label in [title_label, kind_label, description_label, equipped_label]:
		label.size.x = details.size.x
	open_button.position = Vector2(40, size.y - 88)
	queue_redraw()

func _select(id: String) -> void:
	selected = id
	var item: Dictionary = ITEMS[0]
	for entry in ITEMS:
		if entry.id == id:
			item = entry
	kind_label.text = item.kind
	title_label.text = item.title
	title_label.tooltip_text = item.title
	description_label.position.y = 104 + mini(2, title_label.get_line_count()) * title_label.get_line_height() + 8
	description_label.text = item.description
	stat_label.text = item.stat
	weight_label.text = item.weight
	detail_icon.texture = icons[id]
	for index in range(item_buttons.size()):
		var is_selected: bool = ITEMS[index].id == id
		item_buttons[index].add_theme_stylebox_override("normal", _style("44513a" if is_selected else "2d372b", "e4bd76" if is_selected else "56604b", 2 if is_selected else 1))
		count_labels[index].text = "E" if ITEMS[index].id == equipped else ITEMS[index].count
	var can_equip: bool = id in ["bow", "knife", "charm"]
	equip_button.disabled = not can_equip or id == equipped
	equip_button.text = "Equipped" if id == equipped else ("Equip" if can_equip else "Cannot equip")
	var equipped_title := ""
	for entry in ITEMS:
		if entry.id == equipped:
			equipped_title = entry.title
	equipped_label.text = "Equipped: " + equipped_title
	equipped_label.tooltip_text = equipped_label.text

func _equip() -> void:
	if equip_button.disabled:
		return
	equipped = selected
	_select(selected)
	for index in range(ITEMS.size()):
		if ITEMS[index].id == selected:
			item_buttons[index].grab_focus()

func _close() -> void:
	is_open = false
	panel.hide()
	open_button.show()
	open_button.grab_focus()
	queue_redraw()

func _open() -> void:
	is_open = true
	open_button.hide()
	panel.show()
	for index in range(ITEMS.size()):
		if ITEMS[index].id == selected:
			item_buttons[index].grab_focus()
	queue_redraw()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE and is_open:
			_close()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_I:
			if is_open:
				_close()
			else:
				_open()
			get_viewport().set_input_as_handled()

func get_test_state() -> Dictionary:
	return {"selected": selected, "equipped": equipped, "is_open": is_open}

func _label(parent: Node, text: String, at: Vector2, dimensions: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.position = at
	label.size = dimensions
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func _button(parent: Node, text: String, node_name: String, minimum: Vector2) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.custom_minimum_size = minimum
	button.size = minimum
	button.add_theme_color_override("font_color", INK)
	button.add_theme_color_override("font_disabled_color", Color("a6aa91"))
	button.add_theme_stylebox_override("normal", _style("344030", "697457"))
	button.add_theme_stylebox_override("hover", _style("46543b", "c0b180"))
	button.add_theme_stylebox_override("pressed", _style("536044", "e4bd76", 2))
	button.add_theme_stylebox_override("disabled", _style("2d372b", "56604b"))
	var focus := _style("00000000", "f6dc9c", 2)
	focus.expand_margin_left = 4
	focus.expand_margin_top = 4
	focus.expand_margin_right = 4
	focus.expand_margin_bottom = 4
	button.add_theme_stylebox_override("focus", focus)
	parent.add_child(button)
	return button

func _style(background: String, border: String, width: int = 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(background)
	style.border_color = Color(border)
	style.set_border_width_all(width)
	style.set_corner_radius_all(3)
	return style

func _line(parent: Node, at: Vector2, dimensions: Vector2) -> void:
	var line := ColorRect.new()
	line.color = Color("596047")
	line.position = at
	line.size = dimensions
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(line)

func _icon(id: String) -> ImageTexture:
	var art := ""
	match id:
		"bow": art = '<g fill="none" stroke="#cfad6c" stroke-width="4" stroke-linecap="round"><path d="M18 4Q62 32 18 60V4"/><path d="M6 32H55M47 26 55 32 47 38" stroke="#e5d9b6" stroke-width="3"/></g>'
		"knife": art = '<path d="m26 47 6-43 10 6-8 37Z" fill="#c5c9b4"/><path d="M15 46H45" stroke="#cfad6c" stroke-width="5"/><path d="m30 49-3 14" stroke="#a4784c" stroke-width="8"/>'
		"charm": art = '<path d="M32 3C-3 20 13 54 32 60 54 47 62 23 32 3Z" fill="#93aa78"/><path d="M32 12V55M32 32 20 24M32 43 44 34" stroke="#dae0b6" stroke-width="2"/>'
		"potion": art = '<path d="M25 6H39V20Q57 46 45 57H19Q7 46 25 20Z" fill="#bc855b" stroke="#debb8a" stroke-width="2"/><path d="M24 4H40" stroke="#92704a" stroke-width="7"/><path d="M22 37H42" stroke="#e5b67a" stroke-width="3"/>'
		"ore": art = '<path d="m8 40 10-27 25-7 16 30-18 19-27-2Z" fill="#999783"/><path d="m18 13 9 29L43 6M27 42l32-6" fill="none" stroke="#cbc5a1" stroke-width="2"/>'
	var image := Image.new()
	var error := image.load_svg_from_string('<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">' + art + '</svg>')
	assert(error == OK, "Item icon could not render")
	return ImageTexture.create_from_image(image)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("1c2a25"))
	var scale_x: float = size.x / 1280.0
	var scale_y: float = size.y / 720.0
	var hill := PackedVector2Array([Vector2(0, 170), Vector2(70, 115), Vector2(140, 177), Vector2(240, 100), Vector2(340, 163), Vector2(450, 120), Vector2(570, 187), Vector2(680, 125), Vector2(780, 172), Vector2(890, 95), Vector2(1000, 159), Vector2(1130, 105), Vector2(1280, 173), Vector2(1280, 720), Vector2(0, 720)])
	for index in range(hill.size()):
		hill[index] *= Vector2(scale_x, scale_y)
	draw_colored_polygon(hill, Color("26372c"))
	draw_colored_polygon(PackedVector2Array([Vector2(0, size.y * 0.8), Vector2(size.x * 0.4, size.y * 0.77), Vector2(size.x, size.y * 0.82), size, Vector2(0, size.y)]), Color("344332"))
	for tree_x in [50.0, 113.0, 1212.0]:
		var x: float = tree_x * scale_x
		draw_colored_polygon(PackedVector2Array([Vector2(x, 0), Vector2(x + 22, 0), Vector2(x + 48, size.y), Vector2(x - 18, size.y)]), Color("15241f"))
	if theme != null:
		draw_string(theme.default_font, Vector2(48, size.y - 44), "THE OLD WOOD", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, MUTED)
