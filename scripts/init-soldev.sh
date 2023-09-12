#!/usr/bin/env bash
# Init the internal/_contracts with sol development toolchain.

set -eux -o pipefail

function initForge() {
    forge init --force --no-git --no-commit internal/_contracts
}

function initHardHat() {
    echo "init HardHat"
    cd internal/_contracts
    nvm use 18.0.0
    pnpm init
    pnpm install hardhat
}

read -rp "Init you sol dev tool! Enter 1 for Forge or 2 for HardHat: " choice

case "$choice" in
1)
    initForge
    ;;
2)
    initHardHat
    ;;
*)
    echo "Invalid choice"
    ;;
esac
