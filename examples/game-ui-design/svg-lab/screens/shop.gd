extends Control

var gold := 72
var owned := 0
var stock := 2
var selected := "tonic"
var panel: PanelContainer
var heading: Label
var eyebrow: Label
var purse: Label
var hint: Label
var title: Label
var category: Label
var description: Label
var availability: Label
var buy: Button
var first_item: Button
var premium_item: Button
var artwork: ItemArt

class ItemArt extends Control:
	var moonstone := false
	func _draw() -> void:
		var c := size / 2.0
		draw_circle(c, 65.0, Color("2c2639"))
		if moonstone:
			var points := PackedVector2Array([c + Vector2(0, -49), c + Vector2(34, 0), c + Vector2(0, 49), c + Vector2(-34, 0)])
			draw_colored_polygon(points, Color("a49cda"))
			draw_line(c + Vector2(0, -44), c + Vector2(-10, 0), Color("e1ddf5"), 2.0, true)
		else:
			draw_style_box(make_box(Color("c4a278"), Color("c4a278"), 3), Rect2(c + Vector2(-17, -51), Vector2(34, 25)))
			var bottle := PackedVector2Array([c + Vector2(-23, -27), c + Vector2(23, -27), c + Vector2(31, 38), c + Vector2(18, 46), c + Vector2(-18, 46), c + Vector2(-31, 38)])
			draw_colored_polygon(bottle, Color("a86048"))
			draw_polyline(bottle + PackedVector2Array([bottle[0]]), Color("e3a76b"), 2.0, true)
			draw_colored_polygon(PackedVector2Array([c + Vector2(-17, -6), c + Vector2(17, -6), c + Vector2(21, 29), c + Vector2(0, 34), c + Vector2(-21, 29)]), Color("eab273"))
	func _notification(what: int) -> void:
		if what == NOTIFICATION_RESIZED:
			queue_redraw()
	static func make_box(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
		var box := StyleBoxFlat.new()
		box.bg_color = fill
		box.border_color = border
		box.set_corner_radius_all(radius)
		return box

func _ready() -> void:
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Segoe UI", "DejaVu Sans", "Arial"])
	theme = Theme.new()
	theme.default_font = font
	theme.default_font_size = 18
	theme.set_color("font_color", "Label", Color("eee6d8"))
	eyebrow = label(self, "LANTERN ROW / TRADER 04", 13, Color("b8a3c4"))
	heading = label(self, "The night market", 32)
	purse = label(self, "72 coins", 24, Color("e5bf78"))
	purse.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hint = label(self, "Arrow keys or Tab to browse · Enter to select", 16, Color("a39aaf"))
	panel = PanelContainer.new()
	panel.name = "MarketPanel"
	panel.add_theme_stylebox_override("panel", box("1d1c2d", "4c405a", 8))
	add_child(panel)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	panel.add_child(margin)
	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 29)
	margin.add_child(columns)
	var stock_column := VBoxContainer.new()
	stock_column.custom_minimum_size.x = 282
	stock_column.add_theme_constant_override("separation", 12)
	columns.add_child(stock_column)
	label(stock_column, "TRADER'S STOCK", 13, Color("b8a3c4"))
	first_item = button(stock_column, "FirstItemButton", "Ember tonic\n28 coins / 2 in stock", Vector2(282, 88))
	first_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	premium_item = button(stock_column, "PremiumItemButton", "Moonstone\n120 coins / rare charm", Vector2(282, 88))
	premium_item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	var stock_space := Control.new()
	stock_space.size_flags_vertical = SIZE_EXPAND_FILL
	stock_column.add_child(stock_space)
	label(stock_column, "Choose carefully. Travel light.", 16, Color("a39aaf"))
	var separator := VSeparator.new()
	separator.add_theme_stylebox_override("separator", box("40374c", "40374c", 0))
	separator.custom_minimum_size.x = 1
	columns.add_child(separator)
	var details := VBoxContainer.new()
	details.size_flags_horizontal = SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 12)
	columns.add_child(details)
	artwork = ItemArt.new()
	artwork.custom_minimum_size.y = 190
	artwork.mouse_filter = MOUSE_FILTER_IGNORE
	details.add_child(artwork)
	category = label(details, "PROVISIONS / CONSUMABLE", 13, Color("b8a3c4"))
	title = label(details, "Ember tonic", 30)
	description = label(details, "A little warmth for the long road.\nRestores 40 warmth. Single use.", 16, Color("a39aaf"))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.custom_minimum_size.y = 60
	description.add_theme_constant_override("line_spacing", 6)
	var detail_space := Control.new()
	detail_space.size_flags_vertical = SIZE_EXPAND_FILL
	details.add_child(detail_space)
	var rule := HSeparator.new()
	rule.add_theme_stylebox_override("separator", box("40374c", "40374c", 0))
	details.add_child(rule)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 18)
	details.add_child(actions)
	availability = label(actions, "2 available", 16, Color("a39aaf"))
	availability.size_flags_horizontal = SIZE_EXPAND_FILL
	availability.size_flags_vertical = SIZE_SHRINK_CENTER
	buy = button(actions, "BuyButton", "Buy · 28", Vector2(160, 48))
	buy.add_theme_stylebox_override("normal", box("d3ad72", "d3ad72", 5))
	buy.add_theme_stylebox_override("hover", box("e4c38e", "e4c38e", 5))
	buy.add_theme_stylebox_override("pressed", box("b88d56", "b88d56", 5))
	buy.add_theme_color_override("font_color", Color("201b26"))
	buy.add_theme_color_override("font_hover_color", Color("201b26"))
	buy.add_theme_color_override("font_pressed_color", Color("201b26"))
	first_item.pressed.connect(select_item.bind("tonic"))
	premium_item.pressed.connect(select_item.bind("moonstone"))
	buy.pressed.connect(purchase)
	resized.connect(layout_screen)
	layout_screen()
	update_item()
	first_item.grab_focus.call_deferred()

func label(parent: Node, text: String, font_size: int, color := Color("eee6d8")) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", color)
	node.mouse_filter = MOUSE_FILTER_IGNORE
	parent.add_child(node)
	return node

func box(fill: String, border: String, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(fill)
	style.border_color = Color(border)
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	return style

func button(parent: Node, id: String, text: String, minimum: Vector2) -> Button:
	var node := Button.new()
	node.name = id
	node.text = text
	node.custom_minimum_size = minimum
	node.add_theme_font_size_override("font_size", 19)
	for state in ["normal", "hover", "pressed", "disabled"]:
		var style := box("242333", "40374c", 5)
		style.content_margin_left = 19
		style.content_margin_right = 19
		node.add_theme_stylebox_override(state, style)
	var focus := box("242333", "f3d19a", 5)
	focus.draw_center = false
	focus.set_border_width_all(2)
	node.add_theme_stylebox_override("focus", focus)
	node.add_theme_color_override("font_color", Color("eee6d8"))
	node.add_theme_color_override("font_disabled_color", Color("8a8290"))
	parent.add_child(node)
	return node

func layout_screen() -> void:
	if panel == null:
		return
	var width := minf(1100.0, maxf(800.0, size.x - 96.0))
	var x := (size.x - width) / 2.0
	panel.position = Vector2(x, 126)
	panel.size = Vector2(width, maxf(500.0, size.y - 220.0))
	eyebrow.position = Vector2(x, 42)
	heading.position = Vector2(x, 65)
	purse.position = Vector2(x + width - 180, 65)
	purse.size = Vector2(180, 38)
	hint.position = Vector2(x, panel.position.y + panel.size.y + 22)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("111322"))
	draw_circle(Vector2(size.x - 220, 95), 48, Color("29293c"))
	var skyline := PackedVector2Array()
	for p in [Vector2(0,610),Vector2(140,490),Vector2(230,550),Vector2(360,420),Vector2(470,540),Vector2(600,470),Vector2(730,580),Vector2(890,440),Vector2(1070,525),Vector2(1190,420),Vector2(1280,500),Vector2(1280,720),Vector2(0,720)]:
		skyline.append(p * size / Vector2(1280, 720))
	draw_colored_polygon(skyline, Color("1b1c2c"))

func select_item(id: String) -> void:
	selected = id
	update_item()

func update_item() -> void:
	var tonic := selected == "tonic"
	title.text = "Ember tonic" if tonic else "Moonstone"
	category.text = "PROVISIONS / CONSUMABLE" if tonic else "CURIOS / RARE CHARM"
	description.text = "A little warmth for the long road.\nRestores 40 warmth. Single use." if tonic else "A pale guide for paths without stars.\nA rare charm for the patient traveler."
	availability.text = (str(stock) + " available" if stock > 0 else "Sold out") if tonic else "Not enough coins"
	buy.text = "Buy · 28" if tonic else "Buy · 120"
	buy.disabled = (stock <= 0 or gold < 28) if tonic else gold < 120
	purse.text = str(gold) + " coins"
	first_item.text = "Ember tonic\n28 coins / " + str(stock) + " in stock"
	for item in [first_item, premium_item]:
		var is_selected: bool = (item == first_item) == tonic
		var item_style := box("332b3c" if is_selected else "242333", "c4a278" if is_selected else "40374c", 5)
		item_style.content_margin_left = 19
		item_style.content_margin_right = 19
		for style_state in ["normal", "hover", "pressed"]:
			item.add_theme_stylebox_override(style_state, item_style)
	artwork.moonstone = not tonic
	artwork.queue_redraw()

func purchase() -> void:
	if selected != "tonic" or stock <= 0 or gold < 28:
		return
	gold -= 28
	stock -= 1
	owned += 1
	update_item()
	if buy.disabled:
		first_item.grab_focus()

func get_test_state() -> Dictionary:
	return {"gold": gold, "owned": owned, "selected": selected, "stock": stock}
