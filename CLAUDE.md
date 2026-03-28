# Corne42 AI Context

## Ecosystem

All ZMK repos live under `~/code/zmk/`. See `~/code/zmk/shared/CLAUDE.md` for shared behaviors, layer defines, and build tools.

## Key Files

| File | Purpose |
|---|---|
| `config/corne.keymap` | Keymap with 9 layers, combos, conditional layers, key position defines |
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
- **Single firmware per half** — runtime OS switching, no separate macOS/Linux builds

## Layers

| # | Layer | Purpose |
|---|---|---|
| 0 | BASE | QWERTY + home row mods (GASC) + combos |
| 1 | COLEMAK | Colemak-DH, toggled via inner thumb combo |
| 2 | DEVLEFT | Programming symbols (left hand) |
| 3 | NPAD | Number pad (right) + navigation (left) |
| 4 | SYSTEM | Bluetooth, media, bootloader, OS toggle |
| 5 | NAV | Arrow keys + F1-F12 + sticky modifiers |
| 6 | WM | Window manager (Linux default: Super+key) |
| 7 | OS_MAC | Ghost flag layer (all &trans), toggled for macOS mode |
| 8 | WM_MAC | macOS WM override (Alt+key), auto-activates via conditional layer when WM + OS_MAC both active |

## Runtime OS Switching

Single firmware works on both macOS and Linux. Toggle `OS_MAC` via `&tog OS_MAC_LAYER` on SYSTEM layer (right inner thumb). When active, the conditional layer swaps WM bindings from `Super+key` (Linux/Hyprland) to `Alt+key` (macOS/AeroSpace).

Combos include `OS_MAC_LAYER` in their `layers` list so they fire in both OS modes.

## Guardrails

- Position numbers differ from Glove80 (42-key vs 80-key) — shared behaviors use position macros defined at the top of each keymap
- Split config: left half is central (USB), right is peripheral (BLE only) — don't enable USB on right
- The `corne.conf` applies to both halves; side-specific settings go in `corne_left.conf` / `corne_right.conf`
- Combos must include `OS_MAC_LAYER` in their `layers` property or they won't fire when macOS mode is active
- Shift uses `hmls`/`hmrs` (faster timing) instead of `hml`/`hmr`
