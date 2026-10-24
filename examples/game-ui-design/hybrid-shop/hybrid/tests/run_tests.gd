extends RefCounted

var host: Control
var results: Array[Dictionary] = []
var failures := 0
var current_id := ""

class PauseProbe extends Node:
	var ticks := 0
	func _process(_delta: float) -> void:
		ticks += 1

func run(root: Control) -> void:
	host = root
	for id in host.SCREENS:
		if not host.test_filter.is_empty() and host.test_filter != id:
			continue
		current_id = id
		host.get_window().size = Vector2i(1280, 720)
		host.show_screen(id)
		await settle()
		await host.capture(id + "-1280x720")
		check_bounds(id + " reference size")
		check(host.get_viewport().gui_get_focus_owner() != null, "initial keyboard focus")
		await key(KEY_TAB)
		check(host.get_viewport().gui_get_focus_owner() != null, "Tab retains usable focus")
		match id:
			"hud": await test_hud()
			"inventory": await test_inventory()
			"pause": await test_pause()
			"shop": await test_shop()
		host.show_screen(id)
		host.get_window().size = Vector2i(1024, 768)
		await settle()
		await host.capture(id + "-1024x768")
		check_bounds(id + " alternate aspect ratio")
		check(host.get_viewport_rect().size == Vector2(1024, 768), "actual viewport resized to 1024x768")
		host.get_tree().paused = false
	var directory: String = host.capture_dir if not host.capture_dir.is_empty() else ProjectSettings.globalize_path("res://evidence")
	var report := {"engine": Engine.get_version_info().string, "renderer": RenderingServer.get_current_rendering_method(), "checks": results.size(), "failures": failures, "results": results, "input": "Synthetic mouse, keyboard and ui_accept actions through the actual Viewport GUI input path. No physical gamepad or touch hardware."}
	var file := FileAccess.open(directory.path_join("test-results.json"), FileAccess.WRITE)
	if file == null:
		push_error("Could not write test results")
		host.get_tree().quit(1)
		return
	file.store_string(JSON.stringify(report, "\t"))
	print("TEST_RESULT ", results.size(), " checks; ", failures, " failures")
	host.get_tree().quit(1 if failures else 0)

func check(passed: bool, message: String) -> void:
	results.append({"screen": current_id, "check": message, "passed": passed})
	if not passed:
		failures += 1
		printerr("FAIL [", current_id, "] ", message)

func node(id: String) -> Control:
	var found: Control = host.current_screen.find_child(id, true, false) as Control
	check(found != null, "native control exists: " + id)
	return found

func state() -> Dictionary:
	return host.current_screen.get_test_state()

func settle(frames := 4) -> void:
	for frame in range(frames):
		await host.get_tree().process_frame

func click(control: Control) -> void:
	if control == null:
		return
	var point := control.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new()
	motion.position = point
	motion.global_position = point
	host.get_viewport().push_input(motion, true)
	for down in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = point
		event.global_position = point
		event.button_index = MOUSE_BUTTON_LEFT
		event.button_mask = MOUSE_BUTTON_MASK_LEFT if down else 0
		event.pressed = down
		host.get_viewport().push_input(event, true)
		await settle(1)
	await settle(2)

func key(code: Key) -> void:
	for down in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.physical_keycode = code
		event.pressed = down
		host.get_viewport().push_input(event, true)
		await settle(1)
	await settle(2)

func accept_action() -> void:
	for down in [true, false]:
		var event := InputEventAction.new()
		event.action = "ui_accept"
		event.pressed = down
		event.strength = 1.0 if down else 0.0
		host.get_viewport().push_input(event, true)
		await settle(1)
	await settle(2)

func check_bounds(context: String) -> void:
	var controls: Array[Control] = []
	collect_controls(host.current_screen, controls)
	var outside: Array[String] = []
	var viewport := host.get_viewport_rect().grow(1)
	for control in controls:
		if control.is_visible_in_tree() and control.size.x > 0 and control.size.y > 0:
			if not viewport.encloses(control.get_global_rect()):
				outside.append(str(control.get_path()))
	check(outside.is_empty(), context + ": visible content inside viewport " + str(outside))

func collect_controls(parent: Node, controls: Array[Control]) -> void:
	for child in parent.get_children():
		if child is Label or child is BaseButton or child is Range:
			controls.append(child)
		collect_controls(child, controls)

func test_hud() -> void:
	var ability := node("AbilityButton") as Button
	var before := state()
	await click(ability)
	check(state().ability_uses == before.ability_uses + 1, "mouse activates Pulse")
	check(state().energy < before.energy, "Pulse consumes energy")
	for i in range(12):
		if ability.disabled:
			break
		ability.grab_focus()
		await accept_action()
	check(state().energy >= 0, "repeated use never spends below zero")
	check(ability.disabled, "insufficient energy disables Pulse")
	var exhausted := state()
	await click(ability)
	check(state().ability_uses == exhausted.ability_uses, "disabled Pulse ignores clicks")
	await host.capture("hud-exhausted")

func test_inventory() -> void:
	var first := node("FirstItemButton")
	var long_item := node("LongItemButton")
	var equip := node("EquipButton")
	await click(first)
	var selected: String = state().selected
	await click(equip)
	check(state().equipped == selected, "Equip applies the selected item")
	await click(long_item)
	check(state().selected != selected, "grid selection updates long-name item")
	check_bounds("long item state")
	await host.capture("inventory-long-name")
	await click(node("CloseButton"))
	check(not state().is_open, "Close dismisses inventory")
	check(node("OpenButton").is_visible_in_tree(), "reopen action appears")
	await click(node("OpenButton"))
	check(state().is_open, "inventory reopens")
	check(host.get_viewport().gui_get_focus_owner() == long_item, "reopening restores selected item focus")

func test_pause() -> void:
	var probe := PauseProbe.new()
	probe.process_mode = Node.PROCESS_MODE_PAUSABLE
	host.add_child(probe)
	check(host.get_tree().paused and state().paused, "opening pause actually pauses SceneTree")
	var ticks_before := probe.ticks
	var settings := node("SettingsButton")
	settings.grab_focus()
	await accept_action()
	check(state().settings_open, "ui_accept opens Settings while paused")
	var slider := node("VolumeSlider")
	slider.grab_focus()
	var volume_before: float = state().volume
	await key(KEY_LEFT)
	check(state().volume != volume_before, "keyboard changes native volume slider")
	check(probe.ticks == ticks_before, "game simulation stays stopped through settings interaction")
	check_bounds("settings state")
	await host.capture("pause-settings")
	await click(node("BackButton"))
	check(not state().settings_open, "Back restores pause menu")
	check(host.get_viewport().gui_get_focus_owner() == settings, "Back restores Settings focus")
	await click(node("ResumeButton"))
	check(not host.get_tree().paused and not state().paused, "Resume unpauses SceneTree")
	await settle()
	check(probe.ticks > ticks_before, "game simulation resumes")
	probe.queue_free()

func test_shop() -> void:
	await click(node("FirstItemButton"))
	var buy := node("BuyButton") as Button
	var before := state()
	await click(buy)
	check(state().owned == before.owned + 1, "buying adds one item")
	check(state().gold == before.gold - 28, "buying deducts the displayed price")
	for i in range(5):
		if buy.disabled:
			break
		await click(buy)
	check(buy.disabled and state().stock == 0, "sold-out purchase is disabled")
	var sold_out := state()
	await click(buy)
	check(state().gold == sold_out.gold and state().owned == sold_out.owned, "disabled buy cannot charge or duplicate stock")
	await host.capture("shop-sold-out")
	await click(node("PremiumItemButton"))
	check(state().selected == "moonstone" and buy.disabled, "unaffordable selection disables purchase")
	check(state().gold >= 0, "wallet never becomes negative")
	await host.capture("shop-unaffordable")
