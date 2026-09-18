# Corne42 AI Context

Read `~/code/zmk/shared/CLAUDE.md` first: it holds the shared behaviors, the `zmk` build tool and the guardrails every board follows, and a session here does not load it.

## Keyboard Details

- **42 keys**: positions 0-35 (keys) + 36-41 (thumbs)
- **Key groups**: `KEYS_L` (0-5, 12-17, 24-29), `KEYS_R` (6-11, 18-23, 30-35), `THUMBS_L` (36-38), `THUMBS_R` (39-41)
- **Board**: Nice!Nano v2 with nice!view display shields
- **ZMK source**: upstream `zmkfirmware/zmk` at `main`, declared in `config/west.yml`
- **Single firmware per half** — runtime OS switching, toggled by `&tog OS_MAC_LAYER` on the SYSTEM layer's right inner thumb. It swaps WM bindings from `Super+key` (Linux/Hyprland) to `Alt+key` (macOS/AeroSpace)

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
pinch. It sits on a left-hand key rather than a thumb because 37 is the
layer key itself, which is why TMUX needs `ltltb`: `ltlt` would resolve the
hold as a backspace when `F` is pressed first. Side effect: shift also reaches
the macros, so zoom and the splits do nothing while it is held. Rename is worse
than nothing — shifted, its `,` becomes `<`, which tmux binds to move the
session left.

## Guardrails

- Position numbers differ from Glove80 (42-key vs 80-key) — never copy positions between them
- Split config: left half is central (USB), right is peripheral (BLE only) — don't enable USB on right
- `config/corne.conf` applies to both halves; side-specific settings go in `config/corne_left.conf` / `config/corne_right.conf`
