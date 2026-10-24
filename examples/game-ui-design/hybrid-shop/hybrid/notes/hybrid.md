# Hybrid shop implementation

The implementation follows `mockups/shop.svg` and its inspected 1280x720 preview, `mockups/shop.png`. The generated concept at `../concepts/shop-concept-v1.png` supplied the storybook art direction. The refined SVG is the layout target. No other branch or earlier UI source was inspected.

`screens/shop.gd` builds native Godot Labels, Buttons, Panels, ColorRects, and TextureRects. Text, wallet values, selection, focus, stock, and purchase actions remain native UI. The three unchanged production PNGs supply the fox portrait and transparent item illustrations. The screen never displays a flattened mockup.

## Layout and type

The reference composition retains ivory panels, moss selection and purchase states, ink type, and copper keyboard focus. The portrait occupies a 440x550 frame on the left. The right column begins at x=528 and ends at x=1240. Item selectors are 348x128 with a 16-pixel gap. The details panel is 712x284. Buy has a 160x48 hit area at x=1048, y=544, matching the mockup. Keyboard focus draws a three-pixel copper outline four pixels beyond its control.

At 1024x768, the portrait frame becomes 352x440 and centers vertically without stretching the fox. The right column begins at x=422.4 and has width 569.6. Item selectors become 276.8x128. Buy stays 160x48. The details artwork and text columns become narrower while body type remains 18 pixels. The heading changes from 36 to 29 pixels and item titles from 25 to 23. Details titles remain 32 pixels. The alternate view is a responsive adaptation; the target includes no separate 4:3 mockup.

Georgia supplies headings and item names. Segoe UI supplies labels and actions. Both use the installed Windows fonts through Godot SystemFont; no font files or new dependencies were added. Other operating systems can substitute fonts and change text metrics.

## Visual comparison

The first successful runtime captures are retained in `evidence/before-linear-filter/`. Comparing them with the mockup revealed speckled aliasing in the downscaled illustrations. Linear filtering alone did not resolve it. The final screen builds mipmaps from the imported textures once and shares them between list and details artwork. Final captures in `evidence/` show smoother item edges and fox detail. They are slightly softer than the browser's PNG resampling. The source images were not changed.

The latest 1280x720, 1024x768, sold-out, unaffordable, and keyboard-Buy-focus captures were opened in the image viewer after the final runner passed. The portrait, margins, panel sizes, small action, and text hierarchy agree with the selected target. Godot font baselines differ by roughly one or two pixels. The visible initial focus outline and unavailable-state copy deliberately extend the static target. The original concept's painted borders, ornamental leaves, and larger purchase action were not the refined implementation target.

The artwork provides the shop's identity and the plain controls leave it readable. This is a visual judgment from the inspected captures. It does not establish an advantage over direct implementation. There is no live gameplay background in this brief.

## Behavior and verification

The existing named seams are `FirstItemButton`, `PremiumItemButton`, `BuyButton`, and `get_test_state()`. Selecting either item changes its title, illustration, description, availability, and purchase state. Two tonic purchases change the wallet from 72 to 44 to 16 coins, owned from 0 to 1 to 2, and stock from 2 to 1 to 0. Buy then disables. Moonstone costs 120 and cannot be purchased.

The native-input runner completed 14 checks with zero failures using Godot 4.7.1 and the OpenGL compatibility renderer. It captured the real viewport at both resolutions and checked mouse purchasing, stock exhaustion, unaffordable selection, initial focus, and visible control bounds. Run it with:

```powershell
.\run-tests.ps1 -Godot Godot
```

A supplemental scratch test sent Tab, Enter, and ui_accept through `Viewport.push_input`, without emitting button signals. Its 20 checks passed. It checked keyboard selection and purchases, skipping disabled Buy, exact reference rectangles, the 160x48 action at both sizes, native aspect-fit artwork, and all artwork/control bounds. It exposed a disabled-Buy focus trap that is now fixed. Disabling Buy after the last keyboard purchase returns focus to the selected item. Reports are `evidence/test-results.json` and `evidence/supplemental-results.json`. `evidence/shop-keyboard-buy-focus.png` records the actual action focus style.

The project uses ordinary imported Texture2D resources. When `.godot` caches are omitted, open `project.godot` in Godot to import its PNGs before launching, or use the supplied runner's import step. A direct game launch without import cannot resolve the preloaded textures. The PNG source files and normal import metadata remain available. Mipmaps are generated in memory, so their quality does not depend on edited image import settings.

The sandbox denied Godot's external `user://` shader-cache directory. Captures and tests completed with shader caching unavailable. Owned test processes exited; timed test launches stop their own process on timeout. This did not require a sandbox or security-setting change.

No persistence, payments, networking, extra inventory system, production dependency, or competing visual direction was added. Physical input hardware, exports, other operating systems, localization, and sizes outside the two requested viewports were not checked.
