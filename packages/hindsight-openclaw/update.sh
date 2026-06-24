#!/usr/bin/env bash
# Update hindsight-openclaw to a new version
# Usage: ./update.sh <version>
# Example: ./update.sh 0.7.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR"
NIX_FILE="$PACKAGE_DIR/package.nix"
SHRINKWRAP_FILE="$PACKAGE_DIR/npm-shrinkwrap.json"

usage() {
  echo "Usage: $0 <version>"
  echo ""
  echo "Update hindsight-openclaw to a new version."
  echo ""
  echo "Steps performed:"
  echo "  1. Download tarball from npm registry"
  echo "  2. Extract and generate npm-shrinkwrap.json"
  echo "  3. Compute npmDepsHash (prefetch-npm-deps)"
  echo "  4. Compute tarball hash (nix-hash --type sha256 --flat --base32)"
  echo "  5. Update package.nix with new version and hashes"
  echo "  6. Copy shrinkwrap to package directory"
  echo ""
  echo "Prerequisites:"
  echo "  - npm (for generating shrinkwrap)"
  echo "  - nix-prefetch-npm-deps (from nixpkgs.npmHooks)"
  echo "  - nix-hash (from nix)"
  echo ""
  echo "Example:"
  echo "  $0 0.7.0"
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

VERSION="$1"

# Validate version format
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "ERROR: Invalid version format. Expected X.Y.Z, got: $VERSION"
  exit 1
fi

echo "=== Updating hindsight-openclaw to v${VERSION} ==="

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# Step 1: Download tarball
echo "[1/6] Downloading tarball..."
TARBALL_URL="https://registry.npmjs.org/@vectorize-io/hindsight-openclaw/-/hindsight-openclaw-${VERSION}.tgz"
TARBALL_FILE="$TMPDIR/hindsight-openclaw-${VERSION}.tgz"

if ! curl -sL -o "$TARBALL_FILE" "$TARBALL_URL"; then
  echo "ERROR: Failed to download tarball from $TARBALL_URL"
  exit 1
fi

if [[ ! -f "$TARBALL_FILE" ]]; then
  echo "ERROR: Tarball not found at $TARBALL_FILE"
  exit 1
fi

echo "  Downloaded: $TARBALL_URL"

# Step 2: Extract and generate shrinkwrap
echo "[2/6] Generating npm-shrinkwrap.json..."
EXTRACT_DIR="$TMPDIR/package"
mkdir -p "$EXTRACT_DIR"
tar xzf "$TARBALL_FILE" -C "$EXTRACT_DIR" --strip-components=1

cd "$EXTRACT_DIR"

# Generate shrinkwrap
if ! npm install --package-lock-only --omit=dev --omit=peer --legacy-peer-deps 2>/dev/null; then
  echo "ERROR: Failed to generate package-lock.json"
  exit 1
fi

# Convert to shrinkwrap
if ! npm shrinkwrap 2>/dev/null; then
  echo "ERROR: Failed to generate npm-shrinkwrap.json"
  exit 1
fi

if [[ ! -f npm-shrinkwrap.json ]]; then
  echo "ERROR: npm-shrinkwrap.json not generated"
  exit 1
fi

echo "  Generated shrinkwrap with $(jq '.packages | length' npm-shrinkwrap.json) packages"

# Step 3: Compute npmDepsHash
echo "[3/6] Computing npmDepsHash..."
NPM_DEPS_HASH=$(nix run nixpkgs#prefetch-npm-deps -- npm-shrinkwrap.json 2>/dev/null)
NPM_DEPS_HASH="${NPM_DEPS_HASH#sha256-}"
echo "  npmDepsHash: sha256-$NPM_DEPS_HASH"

# Step 4: Compute tarball hash
echo "[4/6] Computing tarball hash..."
TARBALL_HASH_B32=$(nix-prefetch-url --type sha256 "$TARBALL_URL" 2>/dev/null | tail -1)
TARBALL_HASH=$(nix hash to-sri --type sha256 "$TARBALL_HASH_B32" 2>/dev/null | sed 's/^sha256-//')
echo "  tarball hash: sha256-$TARBALL_HASH"

# Step 5: Update package.nix
echo "[5/6] Updating package.nix..."

# Update version
sed -i "s/version = \"[0-9]*\.[0-9]*\.[0-9]*\";/version = \"${VERSION}\";/" "$NIX_FILE"

# Update tarball hash
sed -i "s|hash = \"sha256-[A-Za-z0-9+/=]*\";|hash = \"sha256-${TARBALL_HASH}\";|" "$NIX_FILE"

# Update npmDepsHash
sed -i "s|npmDepsHash = \"sha256-[A-Za-z0-9+/=]*\";|npmDepsHash = \"sha256-${NPM_DEPS_HASH}\";|" "$NIX_FILE"

echo "  Updated $NIX_FILE"

# Step 6: Copy shrinkwrap
echo "[6/6] Copying shrinkwrap..."
cp "$EXTRACT_DIR/npm-shrinkwrap.json" "$SHRINKWRAP_FILE"
echo "  Copied to $SHRINKWRAP_FILE"

# Verify
echo ""
echo "=== Update complete ==="
echo "Version: $VERSION"
echo "Tarball hash: sha256-$TARBALL_HASH"
echo "npmDepsHash: sha256-$NPM_DEPS_HASH"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff packages/hindsight-openclaw/"
echo "  2. Build: nix build .#packages.x86_64-linux.hindsight-openclaw --no-link --print-out-paths"
echo "  3. Test: OpenClaw should load the updated plugin"
