#!/usr/bin/env bash
# nixos-install.sh: install NixOS with my config

# Sanity options for safety
set -o errtrace \
	-o errexit \
	-o nounset \
	-o xtrace \
	-o pipefail

# Config constants
readonly CONFIG_REPO="lcx12901/wktlNix" # Dotfile config repo name
readonly FLAKE="github:$CONFIG_REPO"  # Flake URL
readonly MOUNT_DIR="/mnt" # Where drive is mounted by disko (set by disko, not config)
readonly PERSIST_DIR="/persist" # Persistent partition mount location
readonly CONFIG_DIR="$MOUNT_DIR$PERSIST_DIR/flake" # Config location in persistant partition

# Nix flags to use
readonly NIX_FLAGS=("--extra-experimental-features" "nix-command" "--extra-experimental-features" "flakes")

# Select config from flake to install
PS3="Select device config to install: "

# Dynamically retrieve list of available configs
device_list="$(nix "${NIX_FLAGS[@]}" flake show --json $FLAKE |
	nix "${NIX_FLAGS[@]}" run nixpkgs#jq -- --raw-output ".nixosConfigurations | keys[]")"

select device in $device_list "quit"; do
	case $device in
	"q")
		echo "Aborting install"
		exit
		;;
	"")
		echo "ERROR: Invalid selection '$REPLY'"
		REPLY=""
		;;
	*)
		echo "Installing $device config"
		break
		;;
	esac
done </dev/tty # Necessary because otherwise script stdout will be fed back into select statement when piping from curl into bash

# Partition disk with disko
echo "Partitioning disk with disko"
nix "${NIX_FLAGS[@]}" \
	run github:nix-community/disko \
	-- \
	--flake "$FLAKE#$device" \
	--mode zap_create_mount </dev/tty # Necessary because otherwise it can't set LUKS password interactively

# Install NixOS
echo "Installing NixOS and rebooting"
nixos-install --root /mnt --flake "$FLAKE#$device" --no-root-passwd