# Direct native shop

Built from `../../brief.md` in the shared experiment folder, using native Godot Controls and native CanvasItem drawing. No concept image, generated asset, SVG, other branch, or earlier game UI lab source was used as a reference.

## Implementation

- `screens/shop.gd` contains the shop, item state, native Labels and Buttons, and simple native fox, shelf, bottle, and stone drawing.
- The fox's scene uses a uniform scale within the left 32% of the viewport. The right side uses two columns for the shelf and selected item. The primary action is 183 by 52 pixels.
- Georgia is requested through Godot SystemFont for the title and item headings. Other text uses Godot's default font. No fonts or dependencies were installed.
- Selection updates the details and availability. Two tonic purchases turn 72 coins into 16 coins, give two owned tonics, and exhaust the stock. The purchase handler also guards the transaction independently of the disabled button.
- The supplied main scene, project configuration, and test runner were reused without modification.

## Runtime verification

The supplied `run-tests.ps1` completed with Godot 4.7.1 stable and the OpenGL Compatibility renderer. Pass the local Godot executable with its `-Godot` argument.

The final supplied test run passed **14 checks with 0 failures**. It used actual Viewport GUI mouse, key, and input event paths. It checked native controls, initial focus, Tab focus, purchasing, the coin deduction, exhausted stock, disabled purchase protection, unaffordable selection, and visible control bounds at 1280x720 and 1024x768. See `evidence/test-results.json`.

A historical supplemental check passed **6 keyboard checks with 0 failures**. Tab reached Moonstone and Buy, Enter selected Moonstone, and Enter purchased two tonics and disabled the exhausted purchase. That scratch harness and its diagnostic logs are not part of this repository; use the shared runner to reproduce the published 14-check suite.

All test and diagnostic processes exited. Each launch used a hidden window and a bounded wait.

## Visual review and correction

Opened and inspected the actual engine captures at both sizes, plus the final sold-out and unaffordable states.

The first 1280x720 capture showed the window arch clipped by the top edge. The arch now fits inside the illustration. The initial bounds checks also found oversized invisible rectangles on two wrapped Labels because their text was assigned before their width was established. Establishing the root and label layout first fixed both bounds failures.

Before captures are `evidence/first-shop-1280x720.png` and `evidence/first-shop-1024x768.png`. Inspected final captures are `evidence/shop-1280x720.png`, `evidence/shop-1024x768.png`, `evidence/shop-sold-out.png`, and `evidence/shop-unaffordable.png`.

The final normal captures show readable headings and body text, a visible copper initial focus border, a compact Buy action, and a fox with the same proportions at both sizes. The unavailable states use text as well as a disabled style. These are visual observations, not a numerical design score.

## Limits

The fox is a simple flat native illustration. This branch has no painted textures or animation. The requested viewports were checked; smaller sizes, localization, physical gamepad, touch hardware, and a packaged export were not checked.

Godot logged that it could not create its `user://` shader cache. Rendering, screenshots, and the final checks succeeded. One diagnostic launch without an explicit log path failed while trying to create `user://logs`; the bounded retry with an explicit scratch log path succeeded. The supplied runner already uses an explicit log path.

No persistence, real payment, networking, or broader gameplay systems were added. No comparison claim is made about the other branch.
