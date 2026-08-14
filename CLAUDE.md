# Corne42 AI Context

## Ecosystem

All ZMK repos live under `~/code/zmk/`. See `~/code/zmk/shared/CLAUDE.md` for shared behaviors, layer defines, and build tools.

## Key Files

| File | Purpose |
| --- | --- |
| `config/corne.keymap` | Keymap with 11 layers, combos, conditional layers, key position defines |
| `config/corne.conf` | Shared config (BT power, debounce, display, pointing) |
| `config/corne_left.conf` | Central-specific (USB, smooth scrolling) |
| `config/corne_right.conf` | Peripheral-specific (USB disabled) |
| `config/west.yml` | West manifest — pulls zmk-shared + upstream ZMK |
| `build.yaml` | Build matrix: nice_nano + corne_left/right + nice_view |
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
| --- | --- | --- |
| 0 | BASE | QWERTY + home row mods (GASC) + combos |
| 1 | COLEMAK | Colemak-DH, toggled via inner thumb combo |
| 2 | SYSTEM | Bluetooth, media, bootloader, OS toggle |
| 3 | NAV | F1-F12 + arrows + sticky modifiers, held on `G` |
| 4 | NPAD | Number pad (right) + navigation (left) |
| 5 | DEVLEFT | Programming symbols (left hand) |
| 6 | ARROW | Arrows on `E S D F`, modifiers on `J K L ;`, held on the inner right thumb |
| 7 | TMUX | tmux panes, windows and sessions, held on the middle left thumb |
| 8 | WM | Window manager (Linux default: Super+key) |
| 9 | OS_MAC | Ghost flag layer (all `&trans`), toggled for macOS mode |
| 10 | WM_MAC | macOS WM override (Alt+key), auto-activates via conditional layer when WM + OS_MAC both active |

The TMUX layer emits finished chords and prefix macros, so every action is two
keys. That is the whole reason it exists — NAV emits bare arrows, which leaves
the left hand to add Ctrl or Ctrl+Shift and makes the same action three or four.
Position 16 — `F` — inside the layer is `&kp LSHIFT`, which turns pane
navigation into pane resize without a second layer, held as a thumb-and-index
pinch. It sits on a left-hand key rather than a thumb because 37 is now the
layer key itself, which is why TMUX needs `ltltb`: `ltlt` would resolve the
hold as a backspace when `F` is pressed first. Side effect: shift also reaches
the macros, so zoom and the splits do nothing while it is held. Rename is worse
than nothing — shifted, its `,` becomes `<`, which tmux binds to move the
session left.

## Runtime OS Switching

Single firmware works on both macOS and Linux. Toggle `OS_MAC` via `&tog OS_MAC_LAYER` on SYSTEM layer (right inner thumb). When active, the conditional layer swaps WM bindings from `Super+key` (Linux/Hyprland) to `Alt+key` (macOS/AeroSpace).

Combos include `OS_MAC_LAYER` in their `layers` list so they fire in both OS modes.

## Guardrails

See `~/code/zmk/shared/CLAUDE.md` guardrails for the universal build-before-commit rule and the runtime-OS-switching rules (combos must include `OS_MAC_LAYER`; Shift uses `hmls`/`hmrs`) — corne42 is a runtime-OS-switching board, so both apply here. Board-specific:

- Position numbers differ from Glove80 (42-key vs 80-key) — shared behaviors use position macros defined at the top of each keymap
- Split config: left half is central (USB), right is peripheral (BLE only) — don't enable USB on right
- The `corne.conf` applies to both halves; side-specific settings go in `corne_left.conf` / `corne_right.conf`
