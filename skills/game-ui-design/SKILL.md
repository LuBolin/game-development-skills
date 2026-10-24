---
name: game-ui-design
description: "Design, refine, and implement game UI through SVG or image mockups, rendered visual review, and in-engine screenshot comparison. Use for HUDs, menus, inventory, dialogs, and other game screens when visual design or fidelity matters. Skip concept work for behavior-only fixes."
---

# Game UI design

Resolve visible design choices in a mockup, inspect its actual appearance, then implement the chosen design with the game's existing UI system. Keep source and rendered images available throughout the work.

## Fit the task

- For a new screen or substantial visual redesign, establish a visual target before building production UI nodes.
- For implementation from a supplied mockup, inspect and use that mockup directly. Do not generate competing concepts unless requested.
- For a focused repair, use the current screen or previously accepted design as the target. Fix only the affected area and check the whole composition afterward.
- For design-only requests, deliver the mockup and stop before engine changes. For behavior-only fixes, use the normal coding workflow without a concept stage.

Inspect the supplied images, relevant scene or widget files, neighboring screens, fonts, assets, and project instructions. Establish the engine and current UI framework from the project rather than assuming one. Note the screen's purpose, main player action, intended display size or aspect ratios, input devices, and important states. Recover these from context where possible. Ask only for missing information that materially blocks the next step; otherwise state a short assumption and proceed.

For a new visual direction, state a brief art direction grounded in the game's existing assets or inspected references when available. Name concrete choices about type, shapes, materials, and information density. Judge the mockup's hierarchy, copy, control proportions, and game identity against that direction before choosing it. Without references, identify the direction as an assumption. A supplied or already chosen target does not require a new art-direction exercise.

## Choose a visual route

| Need | Preferred route |
| --- | --- |
| Layout, hierarchy, exact labels, panel proportions, or small revisions | SVG mockup |
| Unsettled art direction, painted frames, textures, illustrated controls | Generated image concepts |
| Illustrated artwork with precise layout and readable labels | Raster artwork combined with SVG layout and text |
| Existing screen with a small local defect | Current render and a focused source edit |

Honor an explicitly requested route. Image generation is optional, not a mandatory step before SVG. An accepted image does not need an SVG reconstruction unless the extra layout control will help. Do not hand-trace painted detail just to make everything vector.

Use available image-generation tools when bitmap work is needed, following the installed `imagegen` skill when present. If generation is unavailable, use existing artwork or SVG for suitable layout tasks. If an explicitly requested image or hybrid route needs unavailable generation, state that limit and deliver only the work that can be verified. Use the relevant Figma workflow only for a requested Figma deliverable. Preserve the requested game engine and UI framework. Use existing capture and rendering tools; ask before adding a production dependency.

### SVG mockups

- Choose a reference canvas that matches the game view. Set an explicit `viewBox`, and keep the intended preview size with the source.
- Use simple named groups for meaningful UI parts, reusable styles, and real text elements for labels. Keep geometry readable enough for a later agent to edit.
- Use realistic game data and exact labels where supplied. Avoid adding explanatory copy, tooltips, badges, or controls merely to fill space.
- Prefer existing game icons and assets. Generate artwork where needed rather than accumulating complex paths to imitate painted assets.
- Keep asset references portable with the deliverable. Do not turn a raster screenshot inside an SVG wrapper into a claim of editable vector UI.
- Render using a supported browser or an available SVG renderer. Source inspection and valid XML do not establish visual quality.

### Image and hybrid mockups

Ground the prompt in the actual game view, references, intended dimensions, UI density, and player action. Separate concept artwork from production assets. Inspect the returned image before accepting it. Refine the current image with specific edits when possible; preserve the accepted composition and retain earlier candidates.

When adapting an image into SVG or native UI, identify the type, shapes, materials and ornament that carry its visual identity. Preserve those features with suitable raster layers or stretch-safe assets instead of dropping them to simplify vector drawing. Record deliberate simplifications alongside the original concept. A close match to a simplified SVG does not establish fidelity to that concept.

For hybrid work, let artwork provide materials and illustration while SVG provides controlled layout and labels. Keep changing values and interactive labels separate from decorative art in the final engine UI. Reuse accepted artwork and generate only missing assets needed for the chosen screen. Local layout or copy changes normally need SVG or engine edits, not a new full-screen image. Do not assume every mockup font or image detail is available as a production asset.

## Render, inspect, revise

Before review, read [game-ui-review.md](references/game-ui-review.md) and apply only the checks relevant to this screen.

1. Render the current candidate at the intended display size. For an image candidate, open the actual generated image. Review the whole screen first, then use crops for details.
2. Feed the fresh rendered image to an image-viewing or vision-capable tool and inspect it. A screenshot saved on disk, a successful render command, or the SVG text alone is not visual inspection.
3. Compare with the brief, chosen references, and best previous candidate. Identify one or two concrete visible problems, their location, and a proposed correction. Distinguish an observed defect from a style preference.
4. Make the smallest useful correction, render again, and inspect the fresh result. Check that the change did not break a neighboring area. Keep the better candidate and revert regressions.

When a visual review leads to a correction, retain a before image and the latest inspected after image with a one-sentence finding. Preserve the evidence of the defect instead of overwriting every earlier capture. A clean first result does not require an invented correction or extra images.

Use up to three review-and-correction passes per screen as a starting budget, not a requirement to make three edits. Stop sooner if there is no clear defect. Extend only for a named unresolved issue with a plausible correction. If the same failure recurs, change the approach or report it instead of restarting an unchanged loop. Do not treat an agent's aesthetic score as proof of improvement.

Work autonomously within an agreed direction. Ask for a choice when materially different art directions remain unresolved, not for approval after every small correction. If the user has already chosen a reference or authorized design selection, carry that forward.

If rendering or image inspection is unavailable, try an existing supported alternative. Preserve the candidate and state exactly which visual check is unverified. Do not claim visual approval or fidelity from source inspection. Continue independent work, but do not silently treat the unreviewed candidate as an accepted new production design.

## Carry the design into the game

Once a target is chosen, keep it stable during implementation. Record the chosen source and preview, reference size, fonts and assets used, key proportions, and any unresolved decisions in the project's existing design notes or a short nearby note. Reuse existing documentation rather than creating a new specification system.

When new artwork or materials are involved, verify a representative asset and intended font in the engine at actual UI size before assembling the rest of the screen. Reuse this checked piece in the implementation.

- Reuse the project's native containers, widgets, themes, prefabs, components, and input conventions. Avoid rebuilding a working UI system.
- Translate proportions into layout constraints and anchors that fit the game. Do not copy absolute coordinates blindly or assume importing an SVG creates editable engine widgets.
- Keep decorative artwork separate from functional controls. Use stretch-safe frames or nine-slice assets when the engine and artwork support them. Verify the actual import instead of assuming browser SVG support matches the engine.
- Preserve dynamic text, quantities, bindings, selection, focus, hit areas, and existing game actions. Map visible controls to real behavior within the requested scope.
- Handle the relevant selected, focused, pressed, disabled, empty, or overflow states. Derive the needed states from the screen's behavior; do not manufacture an exhaustive component library.
- Preserve gameplay visibility and input ownership. Opening or closing a panel must retain the game's intended cursor capture, focus return, pause behavior, and action routing.

Use the engine and UI version already present. Consult current official engine documentation when an importer, API, or layout behavior is uncertain; avoid prescribing engine-specific APIs without inspecting the project.

## Verify the implementation against the target

Capture the actual composed in-engine screen at the reference viewport and relevant state. Open both the target and fresh engine screenshot and compare hierarchy, bounds, spacing, typography, artwork, contrast, and control proportions. Include the gameplay background when it affects readability. A detached widget preview does not establish in-game appearance.

Fix implementation differences without inventing a new visual direction. If a real engine or usability constraint requires a design change, record the reason and update the target deliberately. Use pixel overlays or measurements as aids, not as a substitute for reviewing font, renderer, and gameplay differences.

Exercise the main player action and the input devices the task targets. For automated checks, send input through the engine's real GUI/input path; manually emitting a button signal does not test hit areas, focus, or input routing. Check the relevant alternate aspect ratio, long content, and state changes using the review reference. Run project checks appropriate to the changes. Build success and screenshots establish different things; neither alone proves the screen works.

When delivering a runnable project, verify asset imports from source without relying on a local cache. Include the required import steps and disclose font dependencies.

Deliver the editable mockup source when created, its latest inspected preview, implementation changes when requested, and a short account of the comparisons and interactions actually checked. State unresolved visual, runtime, or asset limitations. Save deliverables in the location required by the current task, and keep scratch files separate.

Assess design quality, reference fidelity, and functional behavior separately. Explain the visual judgment in concrete terms; passing tests or closely matching a mockup does not establish aesthetic quality. Describe untested routes and avoid claiming an advantage over direct implementation without a comparable baseline.

## Maintenance

Read [curation.md](references/curation.md) when revising this workflow or tracing its public sources. It is provenance, not an extra runtime dependency.
