# Corne42 AI Context

## Ecosystem

All ZMK repos live under `~/code/zmk/`. See `~/code/zmk/shared/CLAUDE.md` for shared behaviors, layer defines, and build tools.

## Key Files

| File | Purpose |
|---|---|
| `config/corne.keymap` | Keymap with 5 layers, combos, key position defines |
| `config/corne.conf` | Shared config (BT power, debounce, display, pointing) |
| `config/corne_left.conf` | Central-specific (USB, smooth scrolling) |
| `config/corne_right.conf` | Peripheral-specific (USB disabled) |
| `config/west.yml` | West manifest — pulls zmk-shared + upstream ZMK |
| `build.yaml` | Build matrix: nice_nano + corne_left/right + nice_view |
| `Makefile` | align, draw, build, sync, clean |
| `keymap_drawer.config.yaml` | Keymap-drawer config for this keyboard |
| `keymap_align.toml` | Keymap-align config |

## Keyboard Details

- **42 keys**: positions 0-35 (keys) + 36-41 (thumbs)
- **Key groups**: `KEYS_L` (0-5, 12-17, 24-29), `KEYS_R` (6-11, 18-23, 30-35), `THUMBS_L` (36-38), `THUMBS_R` (39-41)
- **Board**: Nice!Nano v2 with nice!view display shields
- **ZMK source**: `zmkfirmware/zmk@main` (upstream)

## Layers Used

Uses 5 of 7 shared layers: BASE (0), DEVLEFT (1), NPAD (3), SYSTEM (4), NAV (6).
Skips DEVRIGHT (2) and MOUSE (5).

## Guardrails

- Position numbers differ from Glove80 (42-key vs 80-key) — shared behaviors use position macros defined at the top of each keymap
- Split config: left half is central (USB), right is peripheral (BLE only) — don't enable USB on right
- The `corne.conf` applies to both halves; side-specific settings go in `corne_left.conf` / `corne_right.conf`
