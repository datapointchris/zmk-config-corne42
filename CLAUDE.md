# Corne42 AI Context

Read `~/code/zmk/shared/CLAUDE.md` first: it holds the shared behaviors, the `zmk` build tool and the guardrails every board follows, and a session here does not load it.

## Keyboard Details

- **42 keys**: positions 0-35 (keys) + 36-41 (thumbs)
- **Key groups**: `KEYS_L` (0-5, 12-17, 24-29), `KEYS_R` (6-11, 18-23, 30-35), `THUMBS_L` (36-38), `THUMBS_R` (39-41)
- **Board**: Nice!Nano v2 with nice!view display shields
- **ZMK source**: upstream `zmkfirmware/zmk` at `main`, declared in `config/west.yml`
- **Single firmware per half** — runtime OS switching, toggled by `&tog OS_MAC_LAYER` on the SYSTEM layer's right inner thumb. It swaps WM bindings from `Super+key` (Linux/Hyprland) to `Alt+key` (macOS/AeroSpace)

## Layers

The layer numbers are the `#define` block at the top of `config/corne.keymap`, and each must
match its block's position in `keymap`. README § "Layers" describes what each layer holds and how
it is reached.

TMUX opens on `ltltb`, not `ltlt`, because position 16 (`F`) inside it is `&kp LSHIFT`. A plain
`ltlt` would resolve the hold as Backspace when `F` is pressed first. README § "TMUX and ARROW"
explains the layer and what Shift does to its macros.

## Guardrails

- Position numbers differ from Glove80 (42-key vs 80-key) — never copy positions between them
- Split config: left half is central (USB), right is peripheral (BLE only) — don't enable USB on right
- `config/corne.conf` applies to both halves; side-specific settings go in `config/corne_left.conf` / `config/corne_right.conf`
