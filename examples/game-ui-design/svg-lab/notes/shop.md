# Night market

SVG target: `mockups/shop.svg`, 1280x720. Native screen: `screens/shop.gd`. Palette: midnight indigo, muted lavender, warm brass. System font: Segoe UI with platform fallbacks. Two stock choices keep the purchase decision clear; the primary action is 160x48 rather than spanning the detail panel.

The target was rendered with the installed sharp SVG renderer and opened for visual inspection before native implementation. The actual OpenGL Godot viewport was then captured and opened alongside the reference. This exposed an item-selection style override that discarded the button's internal text margins. The selection update now preserves those margins.

The native implementation uses containers for the stock/detail/action layout, live Labels for wallet, name, description, stock and price, and Buttons for selection and purchasing. Decorative bottle/gem art is native drawing. Width adapts to the available view; target proportions are preserved at the reference size without flattening the UI into an image.

Reviewing the unaffordable item's actual hovered state exposed a second theme issue: only the normal style had the selected border. The normal, hovered, and pressed styles now preserve the same selected cue and content margins. Final baseline, unaffordable, and 4:3 captures were opened after this correction.

Deliberate renderer difference: stock choices use native multiline Button text at a uniform size, while the SVG uses a smaller secondary line. The native focus outline is visible and is retained for keyboard use. The decorative bottle uses straight polygon edges instead of the target's curved bottom. These do not change the purchase hierarchy or interaction.

The integration tests exercise native GUI mouse events, wallet deduction, item ownership, stock exhaustion, ignored disabled purchases, and the unaffordable item. Exact outcomes and viewport checks are stored in `evidence/test-results.json`; the accompanying report records which captures were visually inspected. This is a mock game with no real payment, networking, persistence, or physical gamepad test.
