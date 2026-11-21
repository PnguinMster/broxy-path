# Broxy Path

**[▶ Play on itch.io](https://pnguinmster.itch.io/broxy-path)**

A physics-based 2D platformer built from scratch in **Lua** with **LÖVE (Love2D)**. Steer a wobbly two-part block through 9 levels using momentum, rotation and a limited hover thruster.

![Gameplay](docs/screenshot.png)

## Highlights

- **Physics-driven player:** two Box2D bodies joined by a spring-damped weld joint, simulated at a fixed 120 Hz timestep
- **Levels drawn as PNGs:** each pixel's color maps to a block type (solid, bouncy, moving, rotating, exit), so any pixel editor works as the level editor
- **Greedy meshing:** adjacent tiles merge into larger rectangles when a level loads, so there are far fewer physics bodies and draw calls
- **Custom GLSL shaders:** animated starfield and nebula backgrounds, plus a CRT post-process (scanlines, chromatic aberration, vignette)
- **Hand-built UI and scenes:** buttons, sliders and checkboxes that adapt to a resizable window, plus pause and level-complete menus
- **Saved progress and settings:** a sandboxed, type-checked loader, so a corrupt save can't crash the game

## Controls

| Key | Action |
|-----|--------|
| ← / → | Roll left / right |
| ↑ / ↓ | Hover up / thrust down (uses stamina) |
| Esc | Pause |

## Run It

### Option 1: Download from itch.io (easiest)

Get the latest build from **[pnguinmster.itch.io/broxy-path](https://pnguinmster.itch.io/broxy-path)**.

- **Windows (.zip):** extract the zip and run `BroxyPath.exe`. You don't need to install anything.
- **Any platform (.love):** install [LÖVE 11.5](https://love2d.org/), then double-click the `.love` file or run `love broxypath.love`.

### Option 2: Run from source

Install [LÖVE 11.5](https://love2d.org/), then:

```bash
git clone https://github.com/PnguinMster/broxy-path.git
cd broxy-path
love .
```

## What I Learned

Tuning physics so movement feels good, writing shaders and a post-processing pass, and building UI and scene management without an engine.

## License

[MIT](LICENSE) © 2024 MarcoGA
