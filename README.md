# Game development skills

Agent skills for game development, starting with a visual game UI workflow. This is an early collection with runnable Godot examples and recorded test results.

| Skill | Purpose | Evidence |
| --- | --- | --- |
| [game-ui-design](skills/game-ui-design/SKILL.md) | Design with SVG, generated images or a hybrid; inspect the result; implement native game UI and compare engine screenshots | Four-screen SVG lab and a direct-versus-hybrid shop example |

![Direct and hybrid native Godot shops](examples/game-ui-design/hybrid-shop/comparison.png)

Both shops are real Godot interfaces. Artwork supplies illustration; labels, wallet, selection, focus and buying remain native controls. The hybrid deliberately simplifies some of its original concept's painted frames and texture. Read the [example notes](examples/game-ui-design/README.md) before drawing conclusions about design quality or effort.

## Install in Codex

Ask Codex:

```text
$skill-installer Install game-ui-design from https://github.com/LuBolin/game-development-skills/tree/main/skills/game-ui-design
```

The installer places the skill folder in your local skill collection. The examples are separate from the installed skill. Clone this repository if you want to run them.

```text
Use $game-ui-design to design and implement this game's inventory.
Inspect the current project and assets, create a visual target, then compare
the actual engine screen with that target.
```

To request the image and hybrid route explicitly:

```text
Use $game-ui-design. Force the hybrid route: generate and inspect a concept,
prepare separate artwork, refine the layout in SVG, implement native UI,
and compare actual engine screenshots.
```

## Requirements and scope

- A coding agent that can read images, edit files, and run the project's tools.
- A browser or SVG renderer for mockups, and engine screenshot access for implementation review.
- Image generation for new bitmap artwork. SVG and existing-asset workflows do not require it. The skill states a limit if an explicitly requested route needs an unavailable tool.
- The project's existing game engine and UI framework. The instructions are intended to adapt to the project; runtime verification so far covers Godot 4.7.1 on Windows.

No other skill bundle is required. If an image-generation skill is installed, use its tool instructions. The examples need Godot; their automated launchers use Windows PowerShell. Fonts come from the operating system and are not bundled.

## Examples

- [SVG lab](examples/game-ui-design/svg-lab/README.md): HUD, inventory, pause/settings and shop. The shared native-input suite passed 61 checks at two viewport sizes.
- [Hybrid shop](examples/game-ui-design/hybrid-shop/README.md): generated concept, separate artwork, editable SVG, and two native implementations from one written brief. Each branch passed the same 14 checks.
- [Example overview and test commands](examples/game-ui-design/README.md).

The examples use synthetic GUI input and static gameplay backgrounds. They do not establish consistent aesthetic improvement, speed savings, production gameplay behavior or support for other engines. The latest instruction changes have not had a fresh generation trial. GitHub-hosted HTML is source; open `report.html` locally to use its comparison controls.

## Contributing

For a reported problem, include the skill, engine version, brief, expected behavior, actual result, and a screenshot when the issue is visual. Keep proposed changes scoped to an observed problem. Preserve existing projects and player input behavior.

## License and sources

[MIT](LICENSE). The UI illustrations were AI-generated for these examples; no font files are redistributed. Public workflows that informed the skill are credited in [curation notes](skills/game-ui-design/references/curation.md).
