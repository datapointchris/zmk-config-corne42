# zmk-config-corne42

ZMK firmware configuration for the Corne 42-key split keyboard.

## Hardware

- **Board**: Nice!Nano v2
- **Display**: nice!view (both halves)
- **Keys**: 42 (3x6 + 3 thumb per side)
- **Split**: Left = USB/central, Right = BLE/peripheral
- **Pointing**: Enabled with smooth scrolling (central only)

## Layers

| # | Layer | Notes |
|---|---|---|
| 0 | BASE | QWERTY + home row mods + 8 combos (brackets, tilde, underscore, hyphen) |
| 1 | DEVLEFT | Programming symbols (left hand) |
| 3 | NPAD | Number pad (right) + nav (left) |
| 4 | SYSTEM | Bluetooth, bootloader, media, output toggle |
| 6 | NAV | Arrow keys + F1-F12 + sticky modifiers |

Skips layers 2 (DEVRIGHT) and 5 (MOUSE) from the shared set.

## Notable

- Split `.conf` files: `corne.conf` (shared), `corne_left.conf` (USB/central), `corne_right.conf` (peripheral)
- Eager debouncing (1ms press, 10ms release)
- Increased BT TX power (+8dBm)
- Uses upstream ZMK (`zmkfirmware/zmk@main`)
- GitHub Actions builds via `zmkfirmware/zmk/.github/workflows/build-user-config.yml`

## Build

```sh
make build    # Build firmware → corne_left.uf2, corne_right.uf2
make sync     # Align + draw + build
make help     # Show all targets
```

## Ecosystem

See [zmk-shared](https://github.com/datapointchris/zmk-shared) for shared behaviors, layer architecture, and full documentation.
