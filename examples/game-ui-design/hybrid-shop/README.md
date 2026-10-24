# Forced image and hybrid route test

`brief.md` is the shared written shop brief. `direct/` is a native Godot build from that brief. `hybrid/` uses a generated visual concept, separately generated production illustrations, an editable SVG layout, and native Godot Controls. `report.html` compares the routes and runtime states. `evaluation.md` explains the comparison limits.

Open either branch's `project.godot` with Godot 4.7.1 and run it. Godot imports the hybrid PNGs on first editor open. On Windows, run a branch's `run-tests.ps1 -Godot Godot`, substituting the local executable path. The hybrid runner imports source PNGs first, so an unpacked project does not depend on a pre-existing `.godot` cache. Both branches use the same shared native-input assertions and capture both viewport sizes.

The hybrid's `mockups/shop.svg` references the three portable PNG files in `assets/`. Its preview is `mockups/shop.png`. The original generated concept and all four built-in generation/edit prompts are in `concepts/`. No generated UI screenshot is used as a functional interface. Wallet, item data, prices, selection, focus and purchase behavior remain native controls.

The project archive omits regenerable Godot caches and diagnostic logs. The test uses synthetic mouse, key and UI-action events. Physical controllers, touch, audible output, exported executables and production gameplay are outside this test. The known sandbox shader-cache warning did not prevent rendering or input tests. This is one qualitative example; no general aesthetic or speed advantage is claimed.
