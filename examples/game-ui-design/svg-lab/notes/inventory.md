# Inventory design and verification

The field satchel uses a muted forest panel, warm parchment text, brass selection edges, and simple vector item art. The four-column grid carries five items and seven empty slots. Equip is 142 × 44 pixels. Selection has a border; equipped items have an `E` marker and a disabled `Equipped` action. Empty slots do not take focus.

Reference: `mockups/inventory.svg` and its inspected `inventory.png`, 1280 × 720. Fonts are installed Georgia and Segoe UI through Godot SystemFont. Icons are small SVGs rendered to textures by Godot; every label, item button, action, and state is a native Control. The woodland backdrop is a deliberately simple mock scene, not production gameplay.

## Comparison and correction

Opened the actual Sharp-rendered SVG before implementation. The grid/action proportions were accepted. Compared it with a real OpenGL Godot viewport capture, then corrected two differences: restored the missing vertical grid/details separator, and removed excessive blank space below short names by placing the description after the actual title line count. The action row stays fixed so long names cannot move Equip over the footer. Updated the SVG's action/stat positions and keyboard hints to record that deliberate layout choice, rendered it again, and inspected both final images.

The final engine capture preserves the target panel bounds, 98 × 94 item cells, spacing, typography hierarchy, and 142 × 44 Equip action. Small differences remain in font rasterization, the panel's decorative inner border, focus outline, and background tree shapes. These do not obstruct the controls. Native focus has an additional light outer border, distinct from the selected item's brass border.

The long name is `Moonleaf talisman of the First Keeper of the Western Hollow`. It wraps into two readable lines at both tested sizes. The title has a two-line ellipsis limit and a full-name tooltip for longer content. The compact equipped summary deliberately truncates with an ellipsis and also exposes the full name as a tooltip.

## Tests actually run

Reproduce the published native-input checks with the project's `run-tests.ps1`; results are in `evidence/test-results.json`. The suite uses the real GUI input path. Historical development checks also covered additional arrow, Tab, Enter, Escape and reopen paths. That supplemental scratch harness is not part of this repository.

Inspected `evidence/inventory-1280x720.png`, `inventory-long-1280x720.png`, `inventory-equipped-1024x768.png`, and `inventory-closed-1280x720.png`. Captures are real viewport images at 1280 × 720 and 1024 × 768. Test processes used bounded 30-second waits and exited; none were left running. Godot 4.7.1 used the installed OpenGL compatibility renderer, NVIDIA GPU, and Dummy audio driver.

Contract nodes are `FirstItemButton`, `LongItemButton`, `EquipButton`, `CloseButton`, and `OpenButton`. State IDs are `bow`, `knife`, `charm`, `potion`, and `ore`. `get_test_state()` returns selected, equipped, and is_open. Closing focuses OpenButton; reopening focuses the retained selected item. Native keyboard focus changes selection, and Tab reaches the action or close control.

Not checked: physical controller, localization, persistence, real gameplay input ownership, and sizes below 1024 × 768. This isolated fixture uses no production assets or new dependencies. The environment logged an unavailable `user://` shader cache folder; rendering and all checks still completed.
