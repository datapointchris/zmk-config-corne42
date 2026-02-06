# Corne42 ZMK Config Makefile

CONFIG_DIR := config
KEYMAP := $(CONFIG_DIR)/corne.keymap
DRAWER_YAML := corne_keymap.yaml
SVG := corne_keymap.svg

.PHONY: help align draw build sync clean

help:
	@echo "Corne42 ZMK Config"
	@echo "=================="
	@echo ""
	@echo "Workflows:"
	@echo "  sync    - align + draw + build"
	@echo ""
	@echo "Individual Tasks:"
	@echo "  align   - Align Corne keymap"
	@echo "  draw    - Generate SVG from YAML"
	@echo "  build   - Build firmware (outputs: corne_left.uf2, corne_right.uf2)"
	@echo "  clean   - Remove generated files and UF2s"

align:
	keymap-align -k $(KEYMAP)

draw:
	keymap -c keymap_drawer.config.yaml draw $(DRAWER_YAML) > $(SVG)
	@echo "$(SVG) generated"

build:
	zmk-build

sync: align draw build
	@echo "Sync complete"

clean:
	rm -f ./*.uf2 2>/dev/null || true
	@echo "Cleaned"
