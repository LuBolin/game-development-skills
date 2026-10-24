extends Control

const INK := Color("#3e432f")
const MUTED := Color("#756b52")
const MOSS := Color("#526345")
const BORDER := Color("#b5a583")
const TONIC := preload("res://assets/ember-tonic.png")
const MOONSTONE := preload("res://assets/moonstone.png")

var gold := 72
var owned := 0
var stock := 2
var selected := "tonic"
var serif := SystemFont.new()
var sans := SystemFont.new()
var merchant_frame: Panel
var portrait: TextureRect
var divider: ColorRect
var heading: Label
var subtitle: Label
var wallet: Label
var heading_rule: ColorRect
var first_item: Button
var premium_item: Button
var first_icon: TextureRect
var premium_icon: TextureRect
var first_title: Label
var premium_title: Label
var first_price: Label
var premium_price: Label
var detail: Panel
var detail_icon: TextureRect
var detail_title: Label
var description: Label
var detail_rule: ColorRect
var availability: Label
var buy: Button
var hint: Label

func _ready() -> void:
	serif.font_names = PackedStringArray(["Georgia"])
	sans.font_names = PackedStringArray(["Segoe UI"])
	var background := ColorRect.new()
	background.color = Color("#f4ecd7")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	merchant_frame = _panel(self, Color("#e7dcc0"), Color("#95845f"))
	portrait = _art(merchant_frame, _mipmapped(preload("res://assets/fox-portrait.png")))
	divider = _rule(self, Color("#c9bc99"))
	heading = _label(self, "Moonroot Apothecary", 36, true)
	subtitle = _label(self, "Provisions for the path ahead", 18)
	wallet = _label(self, "72 coins", 20)
	wallet.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wallet.add_theme_color_override("font_color", INK)
	wallet.add_theme_stylebox_override("normal", _box(Color("#eee2c4"), Color("#a59165")))
	heading_rule = _rule(self, Color("#b9a77e"))
	first_item = _item_button("FirstItemButton", "Ember tonic", "tonic")
	premium_item = _item_button("PremiumItemButton", "Moonstone", "moonstone")
	first_icon = _art(first_item, _mipmapped(TONIC))
	premium_icon = _art(premium_item, _mipmapped(MOONSTONE))
	first_title = _label(first_item, "Ember tonic", 25, true)
	premium_title = _label(premium_item, "Moonstone", 25, true)
	first_price = _label(first_item, "28 coins", 18)
	premium_price = _label(premium_item, "120 coins", 18)
	detail = _panel(self, Color("#f6eedb"), BORDER)
	detail_icon = _art(detail, first_icon.texture)
	detail_title = _label(detail, "Ember tonic", 32, true)
	description = _label(detail, "Restores 40 warmth.", 18)
	detail_rule = _rule(detail, Color("#c9bc99"))
	availability = _label(detail, "2 available", 18)
	buy = Button.new()
	buy.name = "BuyButton"
	buy.add_theme_font_override("font", sans)
	buy.add_theme_font_size_override("font_size", 20)
	buy.add_theme_color_override("font_color", Color("#fff8e4"))
	buy.add_theme_color_override("font_hover_color", Color("#fff8e4"))
	buy.add_theme_color_override("font_pressed_color", Color("#fff8e4"))
	buy.add_theme_color_override("font_disabled_color", Color("#e8e0cb"))
	buy.add_theme_stylebox_override("normal", _box(MOSS, MOSS))
	buy.add_theme_stylebox_override("hover", _box(Color("#63764f"), MOSS))
	buy.add_theme_stylebox_override("pressed", _box(Color("#3e5036"), MOSS))
	buy.add_theme_stylebox_override("disabled", _box(Color("#8b8c75"), Color("#8b8c75")))
	buy.add_theme_stylebox_override("focus", _focus_box())
	buy.pressed.connect(_purchase)
	detail.add_child(buy)
	hint = _label(self, "Tab to browse · Enter to select", 15)
	first_item.focus_next = first_item.get_path_to(premium_item)
	premium_item.focus_previous = premium_item.get_path_to(first_item)
	buy.focus_previous = buy.get_path_to(premium_item)
	buy.focus_next = buy.get_path_to(first_item)
	resized.connect(_layout)
	_update_shop()
	_layout.call_deferred()
	first_item.grab_focus.call_deferred()

func _box(fill: Color, stroke: Color, width := 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = stroke
	box.set_border_width_all(width)
	box.set_corner_radius_all(5)
	return box

func _focus_box() -> StyleBoxFlat:
	var box := _box(Color.TRANSPARENT, Color("#a46c35"), 3)
	box.draw_center = false
	box.set_expand_margin_all(4)
	return box

func _panel(parent: Control, fill: Color, stroke: Color) -> Panel:
	var panel := Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _box(fill, stroke))
	parent.add_child(panel)
	return panel

func _label(parent: Control, text: String, font_size: int, is_serif := false) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", serif if is_serif else sans)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", INK if is_serif else MUTED)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(label)
	return label

func _mipmapped(texture: Texture2D) -> ImageTexture:
	var image := texture.get_image()
	var error := image.generate_mipmaps()
	assert(error == OK, "Could not prepare artwork for scaled display")
	return ImageTexture.create_from_image(image)

func _art(parent: Control, texture: Texture2D) -> TextureRect:
	var art := TextureRect.new()
	art.texture = texture
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(art)
	return art

func _rule(parent: Control, color: Color) -> ColorRect:
	var rule := ColorRect.new()
	rule.color = color
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rule)
	return rule

func _item_button(id: String, title: String, item: String) -> Button:
	var button := Button.new()
	button.name = id
	button.tooltip_text = "Select " + title
	button.toggle_mode = true
	button.add_theme_stylebox_override("normal", _box(Color("#f1e7ce"), BORDER))
	button.add_theme_stylebox_override("hover", _box(Color("#ece4c9"), Color("#7e8660")))
	button.add_theme_stylebox_override("pressed", _box(Color("#e3e3c3"), Color("#576746"), 2))
	button.add_theme_stylebox_override("hover_pressed", _box(Color("#e3e3c3"), Color("#576746"), 2))
	button.add_theme_stylebox_override("focus", _focus_box())
	button.pressed.connect(func():
		selected = item
		_update_shop()
	)
	add_child(button)
	return button

func _place(control: Control, x: float, y: float, width: float, height: float) -> void:
	control.position = Vector2(x, y)
	control.size = Vector2(width, height)

func _layout() -> void:
	if not is_instance_valid(buy):
		return
	var compact := size.x < 1120
	var left := size.x * 0.4125
	var right_margin := size.x * 0.03125
	var content_width := size.x - left - right_margin
	var art_width := size.x * 0.34375
	var art_height := art_width * 1.25
	_place(merchant_frame, size.x * 0.0203125, (size.y - art_height) * 0.5 - 15, art_width, art_height)
	_place(portrait, 4, 4, art_width - 8, art_height - 8)
	_place(divider, size.x * 0.384375, 40, 1, size.y - 80)
	var top := (size.y - 720) * 0.5
	heading.add_theme_font_size_override("font_size", 29 if compact else 36)
	_place(heading, left, top + 60, content_width - 145, 47)
	_place(subtitle, left, top + 106, content_width, 29)
	_place(wallet, size.x - right_margin - 130, top + 57, 130, 46)
	_place(heading_rule, left, top + 153, content_width, 1)
	var card_width := (content_width - 16) * 0.5
	_place(first_item, left, top + 180, card_width, 128)
	_place(premium_item, left + card_width + 16, top + 180, card_width, 128)
	var icon_width := 76.0 if compact else 96.0
	var text_x := icon_width + 32
	for icon in [first_icon, premium_icon]:
		_place(icon, 16, 13, icon_width, 100)
	for title in [first_title, premium_title]:
		title.add_theme_font_size_override("font_size", 23 if compact else 25)
		_place(title, text_x, 22, card_width - text_x - 12, 39)
	for price in [first_price, premium_price]:
		_place(price, text_x, 65, card_width - text_x - 12, 30)
	_place(detail, left, top + 338, content_width, 284)
	var detail_art_width := 162.0 if compact else 200.0
	var detail_text_x := 202.0 if compact else 250.0
	_place(detail_icon, 20, 28, detail_art_width, 226)
	_place(detail_title, detail_text_x, 24, content_width - detail_text_x - 32, 48)
	_place(description, detail_text_x, 78, content_width - detail_text_x - 32, 38)
	_place(detail_rule, detail_text_x, 132, content_width - detail_text_x - 32, 1)
	_place(availability, detail_text_x, 144, content_width - detail_text_x - 32, 36)
	_place(buy, content_width - 192, 206, 160, 48)
	_place(hint, left, top + 638, content_width, 28)

func _update_shop() -> void:
	var tonic := selected == "tonic"
	wallet.text = "%d coins" % gold
	first_item.set_pressed_no_signal(tonic)
	premium_item.set_pressed_no_signal(not tonic)
	detail_icon.texture = first_icon.texture if tonic else premium_icon.texture
	detail_title.text = "Ember tonic" if tonic else "Moonstone"
	description.text = "Restores 40 warmth." if tonic else "A stone filled with moonlight."
	availability.text = ("%d available" % stock if stock > 0 else "Sold out") if tonic else "Not enough coins"
	buy.text = "Buy · 28" if tonic else "Buy · 120"
	var had_buy_focus := buy.has_focus()
	buy.disabled = not tonic or stock <= 0 or gold < 28
	premium_item.focus_next = premium_item.get_path_to(first_item if buy.disabled else buy)
	first_item.focus_previous = first_item.get_path_to(premium_item if buy.disabled else buy)
	if buy.disabled and had_buy_focus:
		(first_item if tonic else premium_item).grab_focus()

func _purchase() -> void:
	if selected != "tonic" or stock <= 0 or gold < 28:
		return
	gold -= 28
	owned += 1
	stock -= 1
	_update_shop()

func get_test_state() -> Dictionary:
	return {"gold": gold, "owned": owned, "stock": stock, "selected": selected}
