# Pause screen

The chosen reference is `mockups/pause.svg`, rendered to `mockups/pause.png` at 1280x720 with the installed Sharp renderer. I opened the rendered PNG before implementing the screen. The gameplay view is an original, static tactical woodland scene. It remains visible beside the narrow left menu.

The native implementation is `screens/pause.gd`. It uses Godot Buttons, Labels, a native HSlider, VBox/HBox containers, SystemFont with Bahnschrift and Consolas fallbacks, and native drawing for the background. No screenshot replaces the interactive UI. Buttons are 224x50, Back is 150x50, and the slider is 260x32. The menu keeps an 80 px left margin and centers vertically at both tested sizes.

The SceneTree starts paused. The root uses PROCESS_MODE_ALWAYS. Resume unpauses the tree, hides the menu and releases pointer input. Settings focuses VolumeSlider. Escape, controller B or Back returns to the pause menu and restores SettingsButton focus. Escape from the pause menu resumes. The slider changes the Master bus, including mute at zero. Desktop controller A/B mappings are added only when missing from the input map.

## Visual comparison

- Opened the SVG preview and fresh Godot menu captures. The scene shapes, panel bands, 224 px button width, focus outline and spacing match the reference composition. Godot renders the heading baseline about 8 px higher than Sharp. I kept the native font metrics because the hierarchy remains clear and the controls match the target bounds.
- The first Settings capture had no visible slider focus. A native Panel outline now follows slider focus. Opened the corrected captures at both sizes and confirmed the outline is visible.
- The first Settings value extended 40 px beyond the slider. Restricted the native label row to the slider width. The corrected captures align both right edges.
- At 1024x768 the menu retains its type and control sizes. The background adapts to the viewport. No text or interactive control clips. The primary gameplay area stays visible on the right.

## Verification

The published shared runner exercises actual GUI input through Viewport.push_input. Run `run-tests.ps1` and inspect `evidence/test-results.json` to reproduce that suite. It checks pause and resume with a real pausable process as well as settings and focus behavior.

A historical supplemental harness passed 58 checks at 1280x720 and 1024x768, including additional slider, audio-state and synthetic controller paths. Its small result record remains as development evidence; the supplemental scratch harness is not included.

Fresh inspected captures are `evidence/pause/pause-menu-1280x720.png`, `pause-menu-1024x768.png`, `pause-settings-1280x720.png` and `pause-settings-1024x768.png`. The machine-readable result is `evidence/pause/pause-tests.json`. All launched test processes exited or were bounded by a 25-second timeout.

No new dependencies, persistence or extra settings were added. Physical controller hardware and audible output were not checked. Tests used the Dummy audio driver and verified AudioServer state. This dummy project has no moving gameplay simulation; pause was verified through the real SceneTree state. Godot reported a nonfatal user:// shader-cache warning in this sandbox. No production game was changed.
