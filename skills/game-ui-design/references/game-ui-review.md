# Game UI review

Use the relevant checks at mockup review and implementation comparison. Record concrete findings with image paths and affected regions. Do not make every screen satisfy every case below.

## Design defaults

Check for verbose copy, oversized controls and weak hierarchy before production implementation. Follow the project brief and established visual style. Full-width controls and dense interfaces can be appropriate for the game and input device.

- Give controls a width that fits their label, function, input method, and place in the hierarchy. Full-width controls are appropriate when the composition or touch interaction needs them.
- Prefer short action labels and clear grouping over repeated explanations. Preserve required warnings, accessibility labels, and information needed for a player decision.
- Keep the game's visual identity. Do not replace it with a generic website dashboard, a stack of rounded cards, decorative gradients, or tiny status pills without a game-specific reason.
- Design for the actual information density. A strategy HUD and a pause menu need different amounts of content and empty space.
- Use references and accepted screens to resolve taste. Avoid claiming an aesthetic improvement merely because a candidate has more effects or decoration.

## Composition and readability

- At normal play size, can the player find the main action and most important information? Check relative emphasis and grouping before polishing borders or shadows.
- Are margins, baselines, icon sizes, and panel edges coherent? Check competing emphasis, accidental gaps, cramped sections, and excessive button area.
- Does the UI leave the relevant gameplay visible? Check crosshairs, threats, interaction prompts, subtitles, and player or party information where applicable.
- Review over representative bright, dark, or busy gameplay backgrounds. If only a mock background is available, label that limit instead of claiming in-game readability.
- Inspect actual font rendering, text size, line breaks, clipping, and contrast. Cropped or enlarged previews can hide that text is too small at normal play size.
- For new raster artwork, inspect transparent edges, crop, proportions and downscaled detail in the engine at actual UI size. Resolve aliasing or excessive blur with the engine's import and sampling options; browser rendering alone does not establish asset quality.
- Keep important state understandable without color alone. Preserve useful focus indicators and project accessibility settings.

## Relevant data and display cases

Choose cases that can break this screen, rather than generating a complete test matrix.

| Screen or behavior | Useful cases |
| --- | --- |
| Inventory, shop, crafting | Long item name, large quantity or price, empty slots, selected item, unavailable action |
| HUD or combat overlay | Low or empty resource, large values, urgent state, busy background, additional player information if supported |
| Menu or dialog | Long option label, disabled choice, initial focus, cancel, return focus |
| Lists and details | Empty content, largest supported collection, scroll limits, text overflow |
| Supported display modes | Reference view plus a materially different supported aspect ratio or UI scale; safe area if relevant |
| Localization | Existing long translations or representative expansion; right-to-left layout only when supported or requested |

Use the game's existing overflow, abbreviation, scrolling, and localization conventions. Do not silently shrink all text to make one example fit. SVG scaling alone does not specify how a game screen should adapt to a new aspect ratio.

## Input and runtime behavior

- Check the requested mouse, keyboard, controller, or touch path. Visible control size and actual hit area can differ; verify both where it matters.
- For controller or keyboard navigation, check initial focus, navigation order, visible focus, confirm, cancel, and focus restoration. Recheck navigation after an action disables or removes the focused control. Respect the project's action mapping and glyph system.
- Confirm that input does not leak into gameplay or disappear after closing a panel. Preserve intended pause, cursor lock, and modal behavior.
- Keep runtime labels and changing values as real UI content. Decorative art must not bake in a price, resource count, selected state, or action label that can change.
- Check layering, clipping, scrolling, and tooltips in the composed screen. Test motion or transitions when they affect use; a static screenshot cannot establish timing.
- Respect existing reduced-motion, text-scale, contrast, and remapping support. Do not add a new settings system merely to satisfy this checklist.
- Inspect combined states such as selected plus hovered, or disabled plus focused. Replacing native theme styles can discard content margins, selection cues, or focus outlines even when the normal state looks correct.
- At alternate aspect ratios, preserve the proportions of background art and gameplay objects. Crop or reframe deliberately instead of stretching the reference view.

## Useful critique and stopping conditions

A useful finding names an observed location, its player impact, and a scoped correction. For example: "In the inventory preview, the sell button occupies more area than the item details. Reduce its width to fit the label and align it with the action row, while preserving the touch target."

Compare the complete before and after images, even when the fix is local. Keep the reference visible alongside the candidate during implementation review. For source measurements or pixel comparisons, use matching viewport, UI scale, state, and content.

Prioritize missing or obstructed information, unreadable text, broken interaction, and major hierarchy or fidelity differences. Address smaller spacing and material differences after the structure works. Keep the best candidate and record deliberate deviations. Stop when the scoped checks pass or no further change has a clear expected benefit.

Never invent screenshot findings, claim a render was inspected without opening it, or treat an unrun engine check as passed. If access is missing, list the remaining check plainly and keep verified mockup work distinct from unverified runtime work.
