#!/usr/bin/env bash
# Update hindsight-openclaw to a new version
# Usage: ./update.sh <version>
# Example: ./update.sh 0.7.0

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR"
NIX_FILE="$PACKAGE_DIR/package.nix"
LOCK_FILE="$PACKAGE_DIR/pnpm-lock.yaml"

usage() {
  echo "Usage: $0 <version>"
  echo ""
  echo "Update hindsight-openclaw to a new version."
  echo ""
  echo "Steps performed:"
  echo "  1. Download tarball from npm registry"
  echo "  2. Extract and generate pnpm-lock.yaml"
  echo "  3. Compute pnpmDepsHash (prefetch-pnpm-deps)"
  echo "  4. Compute tarball hash (nix-prefetch-url)"
  echo "  5. Update package.nix with new version and hashes"
  echo "  6. Copy lock file to package directory"
  echo ""
  echo "Prerequisites:"
  echo "  - pnpm (for generating lock file)"
  echo "  - nix (for prefetch commands)"
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

# Step 2: Extract and generate pnpm-lock.yaml
echo "[2/6] Generating pnpm-lock.yaml..."
EXTRACT_DIR="$TMPDIR/package"
mkdir -p "$EXTRACT_DIR"
tar xzf "$TARBALL_FILE" -C "$EXTRACT_DIR" --strip-components=1

cd "$EXTRACT_DIR"

# Generate pnpm-lock.yaml
if ! pnpm install --no-frozen-lockfile 2>/dev/null; then
  echo "ERROR: Failed to generate pnpm-lock.yaml"
  exit 1
fi

if [[ ! -f pnpm-lock.yaml ]]; then
  echo "ERROR: pnpm-lock.yaml not generated"
  exit 1
fi

echo "  Generated lock file with $(grep -c 'resolution:' pnpm-lock.yaml || echo 0) packages"

# Step 3: Compute pnpmDepsHash
echo "[3/6] Computing pnpmDepsHash..."
PNPM_DEPS_HASH=$(nix run nixpkgs#prefetch-pnpm-deps -- pnpm-lock.yaml 2>/dev/null || echo "")
if [[ -z "$PNPM_DEPS_HASH" ]]; then
  echo "  WARNING: Could not compute hash automatically."
  echo "  Setting empty hash - build will fail and show correct hash."
  PNPM_DEPS_HASH=""
else
  PNPM_DEPS_HASH="${PNPM_DEPS_HASH#sha256-}"
  echo "  pnpmDepsHash: sha256-$PNPM_DEPS_HASH"
fi

# Step 4: Compute tarball hash
echo "[4/6] Computing tarball hash..."
TARBALL_HASH_B32=$(nix-prefetch-url --type sha256 "$TARBALL_URL" 2>/dev/null | tail -1)
TARBALL_HASH=$(nix hash to-sri --type sha256 "$TARBALL_HASH_B32" 2>/dev/null | sed 's/^sha256-//')
echo "  tarball hash: sha256-$TARBALL_HASH"

# Step 5: Update package.nix
echo "[5/6] Updating package.nix..."

sed -i "/url = .*hindsight-openclaw/{
  N
  s|hash = \"sha256-[A-Za-z0-9+/=]*\"|hash = \"sha256-${TARBALL_HASH}\"|
}" "$NIX_FILE"

if [[ -n "$PNPM_DEPS_HASH" ]]; then
  sed -i "0,/sha256-[A-Za-z0-9+/=]*=/{
    s|hash = \"sha256-[A-Za-z0-9+/=]*\"|hash = \"sha256-${PNPM_DEPS_HASH}\"|
  }" "$NIX_FILE"
fi

echo "  Updated $NIX_FILE"

# Step 6: Copy lock file
echo "[6/6] Copying lock file..."
cp "$EXTRACT_DIR/pnpm-lock.yaml" "$LOCK_FILE"
echo "  Copied to $LOCK_FILE"

# Verify
echo ""
echo "=== Update complete ==="
echo "Version: $VERSION"
echo "Tarball hash: sha256-$TARBALL_HASH"
if [[ -n "$PNPM_DEPS_HASH" ]]; then
  echo "pnpmDepsHash: sha256-$PNPM_DEPS_HASH"
else
  echo "pnpmDepsHash: (empty - build to get correct hash)"
fi
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff packages/hindsight-openclaw/"
echo "  2. Build: nix build .#packages.x86_64-linux.hindsight-openclaw --no-link --print-out-paths"
echo "  3. Test: OpenClaw should load the updated plugin"
