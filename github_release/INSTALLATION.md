# MacSimus v1.0 - Installation Guide

## For End Users

### Option 1: Direct Installation (Recommended)

1. **Download** `MacSimus-v1.0.zip` from the release page
2. **Extract** the zip file (double-click)
3. **Move** `MacSimus.app` to your Applications folder:
   ```bash
   mv ~/Downloads/MacSimus.app /Applications/
   ```
4. **Launch** from Applications folder or Spotlight search
5. **Allow** microphone access when prompted

### Option 2: Command-Line Installation

```bash
# Download and extract
unzip MacSimus-v1.0.zip

# Install to Applications
sudo mv MacSimus.app /Applications/

# Or install to user Applications
mv MacSimus.app ~/Applications/
```

## Security/Gatekeeper Issues

On macOS Monterey and later, you may see a security warning.

### Method 1: Allow in Security & Privacy
1. Go to **System Settings** > **Privacy & Security**
2. Look for "MacSimus was blocked..."
3. Click **"Open Anyway"**
4. Confirm the warning

### Method 2: Remove Quarantine (Command Line)
```bash
xattr -d com.apple.quarantine /Applications/MacSimus.app
```

### Method 3: Right-Click and Open
1. Right-click `MacSimus.app`
2. Select **"Open"** (not double-click)
3. Click **"Open"** in the security dialog

## Permissions

When you first launch MacSimus, it will request:

- **Microphone Access** - For processing audio input
- **System Audio Access** - For system-wide EQ routing

**Go to:** System Settings > Privacy & Security
**Grant** the permissions to use both modes.

## Uninstallation

To remove MacSimus:

```bash
rm -r /Applications/MacSimus.app
```

That's it! All settings are stored in user preferences.

## Troubleshooting

### App Won't Start
- Verify System Settings > Privacy & Security allows MacSimus
- Try removing quarantine: `xattr -d com.apple.quarantine /Applications/MacSimus.app`
- Restart your Mac

### No Audio Processing
- Check microphone is connected and working
- Verify microphone permission granted
- Try different audio input source

### System Audio Not Working
- Check System Settings > Privacy & Security for audio access
- Verify output device is correctly selected in System Audio tab
- Try switching audio devices

### App Crashes
- Check system audio configuration
- Ensure no other audio apps are conflicting
- Report the issue with crash details

## First Run

1. Open MacSimus
2. You should see two tabs: "App Audio" and "System Audio"
3. Click "Start Processing" to begin
4. Adjust any slider to see the EQ curve update
5. Try a preset to hear the effect

## Getting Help

- **Documentation** - See included markdown files
- **GitHub Issues** - Report bugs or request features
- **Source Code** - Modify and rebuild if needed (see BUILD.md)

## For Developers

Want to build from source? See the project GitHub repository.

```bash
git clone <repository>
cd MacSimus
./build.sh
open MacSimus.xcodeproj
# Build with ⌘B and run with ⌘R
```

---

**Need help?** Check the documentation in the source repository.
