MacSimus v1.0 - System-Wide 12-Band EQ for macOS

BUILD INSTRUCTIONS:
===================

This is an unsigned development build. To use the full application:

1. Install Xcode (if not already installed)
   Download from: https://apps.apple.com/us/app/xcode/id497799835

2. Navigate to the MacSimus directory:
   cd /path/to/MacSimus

3. Open the Xcode project:
   open MacSimus.xcodeproj

4. Build the application:
   - Select the MacSimus scheme
   - Press ⌘B to build

5. Run the application:
   - Press ⌘R to run
   - Or click the Run button

FEATURES:
=========
✓ Real-time 12-band EQ
✓ System-wide and app audio routing
✓ Professional presets
✓ Advanced Q-factor and frequency controls
✓ Real-time visualization

PERMISSIONS:
============
The app will request:
- Microphone access (for audio input)
- Audio device access (for system routing)

Grant these in System Preferences > Security & Privacy

TROUBLESHOOTING:
================
If you see a "MacSimus cannot be opened" error:
1. Go to System Preferences > Security & Privacy
2. Click "Open Anyway" next to MacSimus
3. Confirm the warning

For unsigned builds, you may need to:
- Right-click the app and select "Open"
- Allow it in Security & Privacy settings

BUILD COMPONENTS:
=================
- 10 Swift UI components
- C++ audio DSP engine
- Objective-C++ bridges
- 12-band biquad filters
- Real-time audio processing

VERSION: 1.0
BUILD DATE: March 27, 2026
PHASE: 5 Complete (UI Polish & Visualization)
