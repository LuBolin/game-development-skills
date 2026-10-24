# HUD design and verification

The target is `mockups/hud.svg`, rendered and visually inspected as `mockups/hud.png` at 1280x720. The cool green outpost scene uses an amber enemy, mint energy, a small objective at the upper left, and two compact lower corner groups. The middle of the screen stays clear for the relay, drone, player, and crosshair. Bahnschrift is the installed system font, with Segoe UI fallback. No copied font files or new dependencies.

`screens/hud.gd` builds native Labels, ProgressBars, Containers, a PanelContainer, and one native Button named `AbilityButton`. The decorative dummy world uses CanvasItem drawing. Resource values, objective, distance, ability text, and unavailable status remain native text. The HUD keeps 32 pixel edge margins. The world preserves its aspect ratio and crops horizontally at 1024x768. The UI does not shrink.

Pulse costs 25 energy. Mouse click, Q, or focused keyboard confirmation uses the same native button action. Starting energy is 60. Two uses leave 10 and disable the action. The visible unavailable message reads `LOW ENERGY / NEED 25`, and the resource display shows the 10 remaining energy. The action also guards the energy check before subtraction. `get_test_state()` returns `energy` and `ability_uses`.

## Comparisons and fixes

1. Inspected the rendered SVG before implementation. Its corner groups and contrasting objective stayed readable over the stylized scene. No unrelated concept variants were generated.
2. Opened the first real Godot capture alongside the target. Native container defaults placed the vitals rows too close together and left unused space below them. Explicit row heights now distribute the resource labels and bars through the reference panel. The objective text baseline was also 6 to 10 pixels too high. Its top offset and row spacing now match the target. A mint rail was moved into a native ColorRect so the panel no longer paints over it.
3. Inspected both final sizes and both unavailable captures. The first 4:3 scene stretched the moon and player horizontally. Uniform world scaling now preserves their shapes and keeps the relay centered. HUD labels, bars, and button remain at readable native sizes. No clipping or overlap was observed. Godot polygon edges differ slightly from the antialiased SVG. The ability uses one 18 pixel native button label rather than the SVG's separate 14 and 20 pixel text. The initial focus ring is intentionally visible and sits outside the button.

## Checks actually run

Reproduce the published native-input checks with the project's `run-tests.ps1`. The shared suite launches the real OpenGL compatibility renderer, pushes GUI input through the viewport, and records results in `evidence/test-results.json`. Historical development checks also exercised disabled mouse, Q and Enter attempts; their scratch harness is not part of this repository.

Final images opened for visual review:

- `evidence/hud-1280x720.png`
- `evidence/hud-1024x768.png`
- `evidence/hud-low-energy-1280x720.png`
- `evidence/hud-low-energy-1024x768.png`

All HUD test processes exited. No shared project file or other screen was edited.

Limits: this is a static dummy gameplay scene, so readability against moving combat, camera movement, and production art remains untested. Physical controller, localization, and alternate font installations were not tested. Godot printed `Can't create shader cache folder, no shader caching will happen: user://`; rendering and input tests still completed successfully. An editor import pass also reported inaccessible AppData editor directories. Runtime source loading and visual capture worked without changing global settings or permissions.
