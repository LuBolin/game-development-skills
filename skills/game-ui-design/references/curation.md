# Curation notes

Reviewed on 2026-10-24. These public workflows informed the selection of practices below. This skill uses original instructions for game UI work; it does not vendor these projects, their scripts, or their tool configuration.

| Public source | Useful practice | Adaptation here |
| --- | --- | --- |
| [idea-to-production: mockup](https://github.com/agentic-underground/idea-to-production/blob/main/plugins/design/skills/mockup/SKILL.md) | Separate mockup production from implementation; render and review candidates; SVG is a possible design artifact | Allow detailed SVG, images, or hybrid work without a web layout prescription or required reviewer agent |
| [ratacat: design-iterator](https://github.com/ratacat/claude-skills/blob/main/skills/design-iterator/SKILL.md) | Screenshot feedback and specific, incremental visual changes | Review the whole game composition as well as details, keep the best candidate, and use a short bounded loop instead of ten mandatory rounds |
| [Leonxlnx: imagegen-skills](https://github.com/Leonxlnx/imagegen-skills) | Generate and inspect a visible reference before implementing it | Make image generation optional; support SVG and existing targets; use native game UI rather than a web frontend |
| [Claude-Code-Game-Studios: ux-design](https://github.com/Donchitos/Claude-Code-Game-Studios/blob/main/.claude/skills/ux-design/SKILL.md) | Consider game screens, HUD roles, interaction patterns, and accessibility | Apply only relevant game checks without adopting a studio-wide specification system or per-section approvals |

## Evidence limits

[VisRefiner](https://arxiv.org/html/2602.05998v1) studies screenshot-to-code refinement. It reports improvements for its trained model and mixed refinement results for baseline models. It does not establish that repeated free-form aesthetic critique always improves game UI, or that SVG is faster than image generation. This skill therefore requires fresh image inspection, concrete corrections, comparison with the best candidate, and stopping when useful progress ends.

No external skill bundle is required. Use the active environment's installed image-generation skill when bitmap work is needed, existing render and capture tools for visual evidence, and the current project's engine conventions for implementation.

## Local Godot forward test

On 2026-10-24, a dummy Godot 4.7.1 project exercised a combat HUD, fantasy inventory, pause/settings flow, and shop. SVG targets and native Controls were rendered and inspected at 1280x720 and 1024x768. The shared runner passed 61 checks through native GUI input, including resource limits, focus return, pause/resume, slider changes, stock and affordability. Visual comparison exposed container spacing, style padding, combined selection/hover, focus-outline, and aspect-ratio defects that were corrected.

This test informed the input-path and combined-state checks in this skill. It used static gameplay illustrations and synthetic input, with no physical controller, moving combat, image-generation route, or direct-build control group. It validates these examples, not general aesthetic superiority or speed.

Review of the exercise also separated three judgments: design quality, faithful implementation, and working behavior. The test gives useful evidence for the last two; it does not establish distinctive art direction or superiority over a direct build. The skill now asks for a concrete visual direction for new designs and separate reporting of those judgments. Review-driven fixes also retain before/after images, so later evaluation can inspect the observed change rather than relying only on final captures and written notes.

## Local image and hybrid test

On the same date, an explicit hybrid request exercised a generated shop concept, three separately generated production illustrations, an editable SVG target, and native Godot UI. A separate direct builder received the same written brief without those visual references. Both branches passed the same 14 native-input checks, with captures and bounds checks at 1280x720 and 1024x768. A fresh hybrid copy imported its source assets and passed without an existing Godot cache.

The hybrid had richer illustration detail, but its SVG target simplified the concept's painted frames and texture. Engine review exposed image aliasing; input testing exposed a focus trap when Buy became disabled. These findings support preserving the original concept during fidelity review, checking representative assets early, and testing navigation after state changes. Reusing the accepted artwork also avoids unnecessary regeneration for local layout changes.

This was one qualitative comparison with unequal prompts, effort and timing. It does not prove a general aesthetic, speed or cost advantage, or test automatic route selection. Physical input hardware, exports, other operating systems and live gameplay remain untested. The instruction changes informed by this exercise have not had a fresh image-generation trial.
