#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

KEYBOARD="corne42"
DOCKER_IMAGE="zmkfirmware/zmk-build-arm:3.5-branch"
CONTAINER_NAME="zmk-build-${KEYBOARD}"
WORKSPACE="/workspaces/zmk-config"

echo -e "${BLUE}Building Corne firmware...${NC}"

if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker not found.${NC}"
    exit 1
fi

ZMK_CONFIG_PATH="$(pwd)"

# Check timestamps before build
left_old_ts=""
right_old_ts=""
if [ -f "corne_left.uf2" ]; then
    left_old_ts=$(stat -c "%Y" corne_left.uf2)
fi
if [ -f "corne_right.uf2" ]; then
    right_old_ts=$(stat -c "%Y" corne_right.uf2)
fi

# Remove any previous container with the same name
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo -e "${YELLOW}Building with Docker...${NC}"

docker run --name "$CONTAINER_NAME" --rm \
  -v "$ZMK_CONFIG_PATH":"$WORKSPACE" \
  -w "$WORKSPACE" \
  "$DOCKER_IMAGE" \
  /bin/bash -c "
    # Initialize west workspace (cached between runs)
    if [ ! -f .west/config ]; then
      echo 'Initializing west workspace...'
      west init -l config/
      west update
    elif [ \"\${FORCE_UPDATE:-}\" = 1 ]; then
      echo 'Forcing west update...'
      west update
    fi

    export ZEPHYR_BASE=${WORKSPACE}/zephyr

    echo 'Building Corne left half...'
    west build -s zmk/app -d build/left -b nice_nano -- \
      -DSHIELD='corne_left nice_view_adapter nice_view' \
      -DZMK_CONFIG=${WORKSPACE}/config \
      -DZephyr_DIR=${WORKSPACE}/zephyr/share/zephyr-package/cmake
    cp build/left/zephyr/zmk.uf2 ${WORKSPACE}/corne_left.uf2

    echo 'Building Corne right half...'
    west build -s zmk/app -d build/right -b nice_nano -- \
      -DSHIELD='corne_right nice_view_adapter nice_view' \
      -DZMK_CONFIG=${WORKSPACE}/config \
      -DZephyr_DIR=${WORKSPACE}/zephyr/share/zephyr-package/cmake
    cp build/right/zephyr/zmk.uf2 ${WORKSPACE}/corne_right.uf2

    echo 'Corne firmware built successfully!'
  "

# Verify files were created and timestamps changed
if [ -f "corne_left.uf2" ] && [ -f "corne_right.uf2" ]; then
    left_new_ts=$(stat -c "%Y" corne_left.uf2)
    right_new_ts=$(stat -c "%Y" corne_right.uf2)
    left_human=$(stat -c "%y" corne_left.uf2)
    right_human=$(stat -c "%y" corne_right.uf2)
    if [ "$left_new_ts" = "$left_old_ts" ] || [ "$right_new_ts" = "$right_old_ts" ]; then
        echo -e "${RED}Corne build failed or did not update UF2 files. Timestamp unchanged.${NC}"
        echo -e "Left: $left_human | Right: $right_human"
        exit 1
    fi
    echo -e "${GREEN}Corne firmware built successfully:${NC}"
    echo "Left UF2: $left_human"
    echo "Right UF2: $right_human"
    ls -lh corne_*.uf2
else
    echo -e "${RED}Corne build failed - no output files found${NC}"
    exit 1
fi
