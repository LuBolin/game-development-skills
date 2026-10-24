extends Control

const INK := Color("303c30")
const IVORY := Color("f7f0dc")
const MOSS := Color("486044")
const COPPER := Color("a9633d")
const MUTED := Color("6c725d")

var gold := 72
var owned := 0
var stock := 2
var selected := "tonic"
var first: Button
var premium: Button
var buy: Button
var wallet: Label
var item_title: Label
var description: Label
var quantity: Label
var price: Label
var availability: Label
var message: Label
var art: Control
var labels := {}
var serif: SystemFont

class ShopArt extends Control:
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func shape(points: Array, fill: Color, line := Color("303c30"), width := 2.0) -> void:
		var polygon := PackedVector2Array(points)
		draw_colored_polygon(polygon, fill)
		polygon.append(polygon[0])
		draw_polyline(polygon, line, width, true)

	func oval(center: Vector2, radius: Vector2, color: Color, outline := true) -> void:
		var points: Array = []
		for i in range(49):
			var angle := TAU * i / 48.0
			points.append(center + Vector2(cos(angle), sin(angle)) * radius)
		shape(points, color, Color("303c30") if outline else color, 2.0)

	func leaf(at: Vector2, angle: float, color := Color("617a4e")) -> void:
		var along := Vector2(cos(angle), sin(angle))
		var across := along.orthogonal()
		shape([at, at + along * 10 + across * 5, at + along * 23, at + along * 11 - across * 5], color, color)

	func bottle(at: Vector2, color: Color, height := 48.0) -> void:
		shape([at + Vector2(-13, 0), at + Vector2(-13, -height + 16), at + Vector2(-6, -height + 10), at + Vector2(-6, -height), at + Vector2(6, -height), at + Vector2(6, -height + 10), at + Vector2(13, -height + 16), at + Vector2(13, 0)], color)
		draw_rect(Rect2(at + Vector2(-8, -height - 4), Vector2(16, 8)), Color("976d45"))
		draw_rect(Rect2(at + Vector2(-9, -23), Vector2(18, 15)), Color("efe4c1"))
		draw_line(at + Vector2(-5, -16), at + Vector2(5, -16), Color("526243"), 2, true)

	func _draw() -> void:
		var scale_factor := minf(size.x / 380.0, size.y / 570.0)
		draw_set_transform((size - Vector2(380, 570) * scale_factor) / 2.0, 0, Vector2.ONE * scale_factor)
		var ink := Color("303c30")
		var wood := Color("a9794e")
		var cream := Color("f4e4c6")
		# The illustration uses one uniform scale so the fox keeps its proportions.
		oval(Vector2(190, 254), Vector2(173, 245), Color("d9dfbb"), false)
		var window: Array = [Vector2(58, 251), Vector2(58, 136)]
		for i in range(49):
			var angle := PI + PI * i / 48.0
			window.append(Vector2(190, 136) + Vector2(cos(angle), sin(angle)) * 132)
		window.append(Vector2(322, 251))
		shape(window, Color("93a483"), ink, 3)
		draw_line(Vector2(190, 10), Vector2(190, 250), ink, 3, true)
		draw_line(Vector2(58, 136), Vector2(322, 136), ink, 3, true)
		for x in [74, 298]:
			draw_line(Vector2(x, 22), Vector2(x + 7, 104), ink, 2, true)
			for j in range(5):
				leaf(Vector2(x + 4, 39 + j * 14), 0.4 if j % 2 else 2.6)
		for i in range(4):
			bottle(Vector2(92 + i * 62, 217), [Color("b7804a"), Color("6a845c"), Color("9eab79"), Color("b26f4b")][i], 38.0 + i * 7)
		draw_rect(Rect2(35, 220, 310, 13), wood)
		draw_rect(Rect2(35, 220, 310, 13), ink, false, 2)
		# Tail, apron and head are separate simple native shapes.
		oval(Vector2(279, 418), Vector2(62, 103), Color("ba623b"))
		oval(Vector2(295, 358), Vector2(43, 47), cream)
		oval(Vector2(185, 406), Vector2(92, 113), Color("c77445"))
		shape([Vector2(130, 335), Vector2(242, 335), Vector2(258, 502), Vector2(111, 502)], Color("536a49"))
		draw_arc(Vector2(185, 337), 36, 0, PI, 24, cream, 4, true)
		draw_rect(Rect2(158, 414, 57, 47), Color("6e835c"))
		leaf(Vector2(185, 450), -1.4, Color("dfd6af"))
		shape([Vector2(111, 292), Vector2(102, 202), Vector2(166, 249)], Color("c77445"))
		shape([Vector2(210, 249), Vector2(271, 202), Vector2(263, 298)], Color("c77445"))
		shape([Vector2(119, 259), Vector2(117, 225), Vector2(146, 251)], Color("dfb48c"))
		shape([Vector2(231, 253), Vector2(257, 225), Vector2(253, 267)], Color("dfb48c"))
		oval(Vector2(187, 291), Vector2(88, 71), Color("c77445"))
		shape([Vector2(106, 284), Vector2(180, 307), Vector2(270, 282), Vector2(247, 329), Vector2(189, 363), Vector2(131, 330)], cream)
		oval(Vector2(154, 286), Vector2(6, 9), ink, false)
		oval(Vector2(224, 286), Vector2(6, 9), ink, false)
		draw_circle(Vector2(156, 283), 2, cream)
		draw_circle(Vector2(226, 283), 2, cream)
		shape([Vector2(178, 315), Vector2(198, 315), Vector2(188, 326)], ink)
		draw_arc(Vector2(188, 325), 13, 0.1, PI - 0.1, 16, ink, 2, true)
		oval(Vector2(138, 308), Vector2(12, 5), Color("d69a73"), false)
		oval(Vector2(239, 308), Vector2(12, 5), Color("d69a73"), false)
		draw_rect(Rect2(28, 477, 325, 52), Color("c89f6b"))
		draw_rect(Rect2(28, 477, 325, 52), ink, false, 3)
		draw_line(Vector2(29, 490), Vector2(351, 490), ink, 2, true)
		oval(Vector2(119, 477), Vector2(25, 14), cream)
		oval(Vector2(248, 477), Vector2(25, 14), cream)
		bottle(Vector2(308, 476), Color("a85d36"), 46)
		shape([Vector2(142, 477), Vector2(145, 457), Vector2(188, 464), Vector2(230, 455), Vector2(234, 477)], cream)
		draw_line(Vector2(188, 464), Vector2(188, 476), ink, 2, true)
		for i in range(4):
			draw_line(Vector2(151, 463 + i * 3), Vector2(177, 467 + i * 2), Color("a79a75"), 1, true)
		draw_set_transform(Vector2.ZERO)

class ItemIcon extends Control:
	var moonstone := false
	func _draw() -> void:
		var ink := Color("303c30")
		var center := size / 2
		if moonstone:
			var points := PackedVector2Array([center + Vector2(0, -30), center + Vector2(22, -10), center + Vector2(14, 25), center + Vector2(-15, 29), center + Vector2(-24, -5)])
			draw_colored_polygon(points, Color("d4dccb"))
			points.append(points[0])
			draw_polyline(points, ink, 2, true)
			draw_line(center + Vector2(0, -30), center + Vector2(-4, 9), ink, 1, true)
			draw_line(center + Vector2(-4, 9), center + Vector2(14, 25), ink, 1, true)
			draw_line(center + Vector2(-4, 9), center + Vector2(-24, -5), ink, 1, true)
		else:
			draw_style_box(_bottle_style(Color("be7141"), ink), Rect2(center - Vector2(20, 13), Vector2(40, 44)))
			draw_rect(Rect2(center - Vector2(9, 27), Vector2(18, 18)), Color("be7141"))
			draw_rect(Rect2(center - Vector2(12, 32), Vector2(24, 10)), Color("8c6840"))
			draw_rect(Rect2(center - Vector2(15, 3), Vector2(30, 21)), Color("f0e2bd"))
			draw_line(center + Vector2(-6, 9), center + Vector2(6, 9), Color("a9633d"), 3, true)

	func _bottle_style(fill: Color, outline: Color) -> StyleBoxFlat:
		var box := StyleBoxFlat.new()
		box.bg_color = fill
		box.border_color = outline
		box.set_border_width_all(2)
		box.set_corner_radius_all(7)
		return box

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia"])
	art = ShopArt.new()
	add_child(art)
	_label("eyebrow", "WILDWOOD REMEDIES", 14, MOSS)
	_label("title", "Moonroot Apothecary", 36, INK, true)
	_label("subtitle", "A little warmth for the road.", 18, MUTED)
	wallet = _label("wallet", "72 coins", 24, INK, true)
	wallet.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label("catalog", "ON THE SHELF", 14, MOSS)
	_label("selected_label", "YOUR SELECTION", 14, MOSS)
	_label("fox_name", "Sable, herbalist", 24, INK, true)
	labels.fox_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label("fox_quote", "\"Come in, wanderer. Rest a while.\"", 17, MOSS)
	labels.fox_quote.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	first = _item_button("FirstItemButton", false)
	premium = _item_button("PremiumItemButton", true)
	first.pressed.connect(_select.bind("tonic"))
	premium.pressed.connect(_select.bind("moonstone"))
	item_title = _label("item_title", "", 32, INK, true)
	description = _label("description", "", 20, MUTED)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	quantity = _label("quantity", "", 17, MUTED)
	price = _label("price", "", 24, INK, true)
	availability = _label("availability", "", 17, MOSS)
	buy = Button.new()
	buy.name = "BuyButton"
	buy.add_theme_font_size_override("font_size", 20)
	buy.pressed.connect(_buy)
	add_child(buy)
	message = _label("message", "", 17, MOSS)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label("keys", "Tab to browse  /  Enter to choose", 15, MUTED)
	_style_button(buy, true)
	first.focus_next = first.get_path_to(premium)
	premium.focus_next = premium.get_path_to(buy)
	buy.focus_next = buy.get_path_to(first)
	first.focus_previous = first.get_path_to(buy)
	premium.focus_previous = premium.get_path_to(first)
	buy.focus_previous = buy.get_path_to(premium)
	resized.connect(_layout)
	_layout()
	_refresh()
	first.grab_focus()

func _label(id: String, text_value: String, font_size: int, color: Color, use_serif := false) -> Label:
	var label := Label.new()
	label.name = id.to_pascal_case()
	label.text = text_value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if use_serif:
		label.add_theme_font_override("font", serif)
	add_child(label)
	labels[id] = label
	return label

func _item_button(id: String, is_moonstone: bool) -> Button:
	var button := Button.new()
	button.name = id
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_font_size_override("font_size", 20)
	add_child(button)
	var icon := ItemIcon.new()
	icon.moonstone = is_moonstone
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.position = Vector2(8, 16)
	icon.size = Vector2(60, 80)
	button.add_child(icon)
	return button

func _box(color: Color, border: Color, border_width := 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(5)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 12
	box.content_margin_bottom = 12
	return box

func _style_button(button: Button, active: bool) -> void:
	var normal := _box(MOSS if active else Color("eee7d0"), MOSS if active else Color("b5b79b"))
	if button != buy:
		normal.content_margin_left = 78
	button.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("58764e") if active else Color("e4e3c7")
	button.add_theme_stylebox_override("hover", hover)
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("394f34")
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("disabled", _box(Color("e2dfce"), Color("b1b19b")))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = COPPER
	focus.set_border_width_all(3)
	focus.set_corner_radius_all(5)
	focus.expand_margin_left = 4
	focus.expand_margin_right = 4
	focus.expand_margin_top = 4
	focus.expand_margin_bottom = 4
	button.add_theme_stylebox_override("focus", focus)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, IVORY if active else INK)
	button.add_theme_color_override("font_disabled_color", MUTED)

func _place(control: Control, x: float, y: float, width: float, height: float) -> void:
	control.position = Vector2(x, y)
	control.size = Vector2(width, height)

func _layout() -> void:
	var left := size.x * 0.32
	var x := left + 36
	var right_width := size.x - x - 42
	var column_width := (right_width - 34) * 0.48
	var details_x := x + column_width + 34
	var details_width := size.x - details_x - 42
	_place(art, 18, 18, left - 36, size.y - 158)
	_place(labels.fox_name, 20, size.y - 125, left - 40, 36)
	_place(labels.fox_quote, 14, size.y - 85, left - 28, 34)
	_place(labels.eyebrow, x, 33, right_width - 120, 24)
	_place(labels.title, x, 59, right_width - 90, 52)
	labels.title.add_theme_font_size_override("font_size", 32 if size.x < 1100 else 36)
	_place(labels.subtitle, x, 113, right_width, 29)
	_place(wallet, size.x - 166, 36, 124, 34)
	_place(labels.catalog, x, 183, column_width, 24)
	_place(labels.selected_label, details_x, 183, details_width, 24)
	_place(first, x, 225, column_width, 112)
	_place(premium, x, 353, column_width, 112)
	_place(item_title, details_x, 219, details_width, 51)
	_place(description, details_x, 282, details_width, 94)
	_place(quantity, details_x, 386, details_width, 28)
	_place(price, details_x, 431, details_width, 35)
	_place(availability, details_x, 470, details_width, 28)
	_place(buy, details_x, size.y - 181, minf(183, details_width), 52)
	_place(message, details_x, size.y - 113, details_width, 45)
	_place(labels.keys, x, size.y - 46, right_width, 25)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), IVORY)
	var left := size.x * 0.32
	draw_rect(Rect2(0, 0, left, size.y), Color("e2e5c9"))
	draw_line(Vector2(left, 0), Vector2(left, size.y), Color("a6ae8a"), 2, true)
	draw_line(Vector2(left + 36, 159), Vector2(size.x - 42, 159), Color("b9b99a"), 1, true)
	draw_line(Vector2(left + 36, size.y - 58), Vector2(size.x - 42, size.y - 58), Color("b9b99a"), 1, true)
	draw_circle(Vector2(size.x - 150, 53), 7, COPPER)

func _select(id: String) -> void:
	selected = id
	_refresh()

func _buy() -> void:
	if selected != "tonic" or stock <= 0 or gold < 28:
		return
	gold -= 28
	owned += 1
	stock -= 1
	_refresh()
	if buy.disabled:
		first.grab_focus()

func _refresh() -> void:
	var tonic := selected == "tonic"
	wallet.text = "%d coins" % gold
	first.text = "Ember tonic\n28 coins  /  %d left" % stock
	premium.text = "Moonstone\n120 coins"
	_style_button(first, tonic)
	_style_button(premium, not tonic)
	item_title.text = "Ember tonic" if tonic else "Moonstone"
	description.text = "A warming brew of emberleaf and honey. Restores a weary spirit." if tonic else "A cool, luminous stone gathered beneath the full moon."
	quantity.text = "%d in your satchel" % owned if tonic else "A rare woodland find"
	price.text = "28 coins" if tonic else "120 coins"
	availability.text = "%d bottles on the shelf" % stock if tonic else "1 stone on the shelf"
	buy.disabled = not tonic or stock <= 0 or gold < 28
	buy.text = "Sold out" if tonic and stock == 0 else ("Need 120 coins" if not tonic else "Buy for 28")
	message.text = "All tucked into your satchel." if tonic and stock == 0 else ("You need %d more coins." % (120 - gold) if not tonic else ("Tucked into your satchel." if owned else "Brewed fresh this morning."))

func get_test_state() -> Dictionary:
	return {"gold": gold, "owned": owned, "stock": stock, "selected": selected}
