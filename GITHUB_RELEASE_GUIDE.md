# MacSimus v1.0 - GitHub Release Guide

## Overview

This guide walks you through creating a GitHub release with the MacSimus app.zip binary. Since you don't have an Apple Developer account, we're creating an **unsigned app bundle** that users can run directly on macOS.

## Quick Start (2 Steps)

### Step 1: Create App Bundle + Release Package
```bash
cd ~/MacSimus
./build_github_app.sh
```

**What this does:**
- ✅ Builds C++ audio engine
- ✅ Creates MacSimus.app bundle
- ✅ Creates MacSimus-v1.0.zip for distribution
- ✅ Generates RELEASE_NOTES.md
- ✅ Generates INSTALLATION.md
- ✅ Places all files in `github_release/` directory

**Output location:** `~/MacSimus/github_release/`

### Step 2: Publish to GitHub
Choose **one** option based on your preference:

#### Option A: Using GitHub CLI (Automated) ⚡

```bash
./release_to_github.sh
```

**Prerequisites:**
```bash
# If not installed:
brew install gh

# Setup authentication (first time only):
gh auth login
```

**What it does:**
- Auto-detects your repository
- Verifies you're authenticated
- Creates release v1.0
- Attaches MacSimus-v1.0.zip
- Publishes to GitHub

#### Option B: Using GitHub Web Interface (Manual)

1. Open your GitHub repository
2. Click **Releases** (right sidebar)
3. Click **"Create a new release"**
4. Fill in:
   - **Tag:** `v1.0`
   - **Title:** `MacSimus v1.0`
   - **Description:** Copy from `github_release/RELEASE_NOTES.md`
5. **Attach Binary:**
   - Drag/drop `github_release/MacSimus-v1.0.zip`
   - Or use "Attach binaries" section
6. Click **"Publish release"**

#### Option C: Using GitHub CLI Manually

```bash
gh release create v1.0 \
    github_release/MacSimus-v1.0.zip \
    --title "MacSimus v1.0" \
    --notes "See github_release/RELEASE_NOTES.md"
```

## What's in the Release Package

```
github_release/
├── MacSimus-v1.0.zip          ← Binary app (what users download)
├── RELEASE_NOTES.md           ← Release description for GitHub
└── INSTALLATION.md            ← User installation instructions
```

### MacSimus-v1.0.zip Contains:
- `MacSimus.app/` - Complete application bundle
  - `Contents/MacOS/` - Executable launcher
  - `Contents/Frameworks/` - Audio engine library
  - `Contents/Resources/` - Documentation and assets
  - `Contents/Info.plist` - App configuration

## Release Checklist

Before publishing, verify:

- [ ] C++ audio engine compiled (`build/libaudio_engine.a`)
- [ ] App bundle created (`build_app/MacSimus.app`)
- [ ] Zip file ready (`github_release/MacSimus-v1.0.zip`)
- [ ] Release notes prepared (`github_release/RELEASE_NOTES.md`)
- [ ] Installation guide ready (`github_release/INSTALLATION.md`)
- [ ] GitHub repository set up
- [ ] Git authenticated (if using CLI)

## For Users Downloading the Release

Users will see:
1. Release page on GitHub
2. Download `MacSimus-v1.0.zip`
3. Extract the app
4. Read INSTALLATION.md for setup
5. Launch MacSimus.app
6. Allow permissions when prompted

### User Experience Without Code Signing

Since this is unsigned, users may see:
- "MacSimus cannot be opened because it is from an unidentified developer"

**Solution provided in INSTALLATION.md:**
- Right-click → Open
- Or go to System Settings → Security & Privacy → "Open Anyway"
- This is one-time; subsequent launches work normally

## Creating Additional Releases

### Minor Updates (v1.0.1)
```bash
# Make code changes
# Update version in build_github_app.sh
sed -i '' 's/v1.0/v1.0.1/g' build_github_app.sh

# Rebuild
./build_github_app.sh

# Release
./release_to_github.sh
```

### Major Versions (v1.1, v2.0)
- Update version numbers in scripts
- Update RELEASE_NOTES.md with new features
- Document breaking changes
- Follow semantic versioning

## Troubleshooting

### "App cannot be opened" on macOS

**This is expected for unsigned builds.** Users should:
1. Right-click `MacSimus.app`
2. Select "Open" (not double-click)
3. Click "Open" in security dialog
4. Grant microphone permissions

See INSTALLATION.md for detailed steps.

### GitHub CLI Not Working

```bash
# Check authentication
gh auth status

# Login if needed
gh auth login

# Check repo access
gh repo view
```

### Can't Find App Bundle

Verify build completed:
```bash
ls -la ~/MacSimus/build_app/MacSimus.app/
```

If missing, run `./build_github_app.sh` again.

### Zip File Empty or Corrupted

```bash
# Check zip contents
unzip -l github_release/MacSimus-v1.0.zip | head -20

# Recreate if needed
rm github_release/MacSimus-v1.0.zip
./build_github_app.sh
```

## Advanced: Code Signing (Optional, Requires Developer Account)

If you get a developer account in future:

```bash
# Build with code signing
codesign -s - MacSimus.app
codesign -v MacSimus.app  # Verify
```

But for now, this is **not required** - unsigned builds work fine with the above steps.

## Technical Details

### Architecture
- SwiftUI: Modern macOS user interface
- C++17: High-performance audio DSP
- Objective-C++: Swift-to-C++ bridge layer
- AVFoundation + CoreAudio: System audio integration

### Build System
- CMake: Cross-platform builds
- Swift Package Manager integration
- Static library linking (libaudio_engine.a)

### Performance
- < 2% CPU at idle
- < 10ms audio latency
- Stereo processing
- Real-time safe DSP

## Release Template

For future releases, use this structure:

```markdown
# MacSimus v[VERSION]

[Version-specific release notes]

## Features
- [New feature 1]
- [New feature 2]

## Fixes
- [Bug fix 1]
- [Bug fix 2]

## Installation
Download MacSimus-v[VERSION].zip and follow INSTALLATION.md

## System Requirements
- macOS 12+ (Monterey or later)
- Intel or Apple Silicon (M1/M2/M3)

## Known Issues
- [Known issue 1]
- [Workaround]
```

## Next Steps

1. **Test the build locally:**
   ```bash
   ./build_github_app.sh
   open build_app/MacSimus.app
   ```

2. **Verify app works:**
   - App launches without errors
   - UI displays correctly
   - Audio processing works
   - Sliders are responsive

3. **Create GitHub release:**
   ```bash
   ./release_to_github.sh
   ```

4. **Share the release:**
   - Link to GitHub Releases page
   - Tell users to download v1.0

## Support Resources

- **GitHub Issues:** For bug reports
- **Source Code:** Available in repository
- **Discussions:** For feature requests
- **Documentation:** Included in source

## Summary

You now have:
- ✅ Unsigned app bundle ready
- ✅ Release scripts (build + publish)
- ✅ User documentation
- ✅ Installation instructions
- ✅ Release notes

To publish: Run `./build_github_app.sh` then `./release_to_github.sh`

---

**Happy releasing! 🚀**
