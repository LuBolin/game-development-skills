# Game UI Lab

A local four-screen Godot 4.7.1 exercise of the game-ui-design skill. Open `project.godot` in Godot and run the project. F1 selects the HUD, F2 the inventory, F3 pause/settings, and F4 the shop. These are independent screen demonstrations, not a complete game.

- HUD: click Pulse or press Q. Two uses exhaust the usable energy.
- Inventory: select an item with mouse or arrows, equip it, and close/reopen with Escape or I.
- Pause: Resume, Settings, Back, and the volume slider work while the SceneTree is paused.
- Shop: buy Ember tonic, exhaust stock, or inspect the unaffordable Moonstone.

`mockups/` contains editable SVG targets and their previews. `screens/` contains native Control implementations. `notes/` records visual comparisons, corrections, and limits. `evidence/test-results.json` contains the shared runner's actual results; images are real OpenGL viewport captures. Small rendering and focus differences from the SVGs are deliberate and recorded.

On Windows, rerun the integration suite with `./run-tests.ps1 -Godot Godot`, substituting the local executable path. Use `-Screen hud`, `inventory`, `pause`, or `shop` for one screen. The runner uses a hidden graphics window, captures images at 1280x720 and 1024x768, sends native GUI input, writes results, and exits. Headless mode uses a dummy renderer and is not a substitute for these visual captures.

The shared run passed 61 checks with zero failures. This exercises SVG-to-native layout and behavior. It does not compare against a direct-build baseline or test physical input hardware, moving production gameplay, image generation, persistence, or all resolutions. Godot reported that its per-user shader cache directory was unavailable in the sandbox; rendering and interaction tests completed. No global settings or security permissions were changed.
