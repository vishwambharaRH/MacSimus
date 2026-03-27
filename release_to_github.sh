#!/bin/bash
# MacSimus - GitHub Release Helper
# Creates a GitHub release with the app.zip binary

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$PROJECT_DIR/github_release"
ZIP_FILE="$RELEASE_DIR/MacSimus-v1.0.zip"
RELEASE_NOTES="$RELEASE_DIR/RELEASE_NOTES.md"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  MacSimus - GitHub Release Helper                             ║"
echo "║  Publishes app.zip to GitHub Releases                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if files exist
if [ ! -f "$ZIP_FILE" ]; then
    echo "❌ Error: $ZIP_FILE not found!"
    echo ""
    echo "Please run ./build_github_app.sh first to create the app bundle"
    exit 1
fi

if [ ! -f "$RELEASE_NOTES" ]; then
    echo "❌ Error: $RELEASE_NOTES not found!"
    echo ""
    echo "Please run ./build_github_app.sh first to create release notes"
    exit 1
fi

echo "Files ready for release:"
echo "  ✓ $ZIP_FILE ($(du -h "$ZIP_FILE" | cut -f1))"
echo "  ✓ $RELEASE_NOTES"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Showing manual release instructions:"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "MANUAL GITHUB RELEASE STEPS"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "1. Install GitHub CLI (optional but recommended):"
    echo "   brew install gh"
    echo ""
    echo "2. Go to your GitHub repository:"
    echo "   https://github.com/yourusername/MacSimus"
    echo ""
    echo "3. Create new release:"
    echo "   • Click 'Releases' (right sidebar)"
    echo "   • Click 'Create a new release'"
    echo ""
    echo "4. Release details:"
    echo "   • Tag: v1.0"
    echo "   • Title: MacSimus v1.0"
    echo "   • Description: Copy content from:"
    echo "     $RELEASE_NOTES"
    echo ""
    echo "5. Attach binary:"
    echo "   • Drag/drop or upload:"
    echo "     $ZIP_FILE"
    echo ""
    echo "6. Publish!"
    echo ""
    exit 0
fi

# GitHub CLI is installed
echo "✓ GitHub CLI detected"
echo ""

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Authenticating with GitHub..."
    gh auth login
fi

# Get repo info
REPO=$(gh repo view --json nameWithOwner -q 2>/dev/null || echo "")

if [ -z "$REPO" ]; then
    echo "❌ Error: Not in a GitHub repository or not authenticated"
    echo ""
    echo "Usage:"
    echo "  1. Make sure you're in a GitHub repository: cd MacSimus"
    echo "  2. Authenticate: gh auth login"
    echo "  3. Run this script again"
    exit 1
fi

echo "Repository: $REPO"
echo ""

# Check if release already exists
if gh release view v1.0 &> /dev/null; then
    echo "⚠️  Release v1.0 already exists!"
    echo ""
    echo "Options:"
    echo "  1. Delete the release and create new one"
    echo "  2. Use a different version tag"
    echo ""
    read -p "Delete existing release? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Deleting release v1.0..."
        gh release delete v1.0 --yes
    else
        echo "Cancelled."
        exit 0
    fi
fi

# Create release
echo "Creating GitHub release..."
echo ""

gh release create v1.0 \
    "$ZIP_FILE" \
    --title "MacSimus v1.0" \
    --notes-file "$RELEASE_NOTES" \
    --draft=false

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ RELEASE PUBLISHED SUCCESSFULLY!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Release URL: https://github.com/$REPO/releases/tag/v1.0"
echo ""
echo "Users can now:"
echo "  1. Visit the release page"
echo "  2. Download MacSimus-v1.0.zip"
echo "  3. Follow INSTALLATION.md instructions"
echo ""
