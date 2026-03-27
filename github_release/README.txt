📱 MacSimus v1.0 - GitHub Release
🎵 System-Wide 12-Band EQ for macOS

================================================================================
ABOUT THIS RELEASE
================================================================================

MacSimus v1.0 is a professional audio equalizer for macOS that lets you:

✓ Apply 12-band parametric EQ to ANY audio on your Mac
✓ Choose from 5 professional presets  
✓ Create unlimited custom presets
✓ See real-time frequency response visualization
✓ Fine-tune Q-factor and frequency per band

================================================================================
WHAT YOU GET
================================================================================

📦 MacSimus-v1.0.zip (48 KB)
   └─ Complete macOS app bundle
      • No external dependencies
      • Works on macOS 12+ (Monterey or later)
      • Intel and Apple Silicon compatible

📄 INSTALLATION.md
   └─ Step-by-step setup guide
      • Where to put the app
      • Permission settings
      • Security & Gatekeeper info

================================================================================
IMPORTANT: UNSIGNED BUILD INFO
================================================================================

WHY IT'S UNSIGNED:
This app is distributed as an "unsigned" build because:
• No Apple Developer account is required
• No code signing certificate needed
• Completely free and open-source

WHAT THIS MEANS FOR YOU:
You might see a warning like:
  "MacSimus cannot be opened because it is from an unidentified developer"

This is 100% NORMAL and EXPECTED. The app is safe - it just isn't signed.

HOW TO FIX IT - Choose ONE method:

METHOD 1: Right-Click and Open ⭐ (Easiest)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Right-click MacSimus.app (don't double-click)
2. Select "Open"
3. Click "Open" in the security dialog
4. Done! Next time you can just double-click

METHOD 2: System Settings
━━━━━━━━━━━━━━━━━━━━━━━━━
1. Try to open the app (you'll get the warning)
2. Go to System Settings > Privacy & Security
3. Look for "MacSimus was blocked..."
4. Click "Open Anyway"
5. Confirm and it'll work

METHOD 3: Command Line (If you're technical)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
xattr -d com.apple.quarantine /Applications/MacSimus.app

After doing THIS ONCE, the app opens normally every time.

================================================================================
SYSTEM REQUIREMENTS  
================================================================================

✓ macOS 12 Monterey or later
✓ Intel or Apple Silicon (M1/M2/M3) Mac  
✓ ~50 MB free space
✓ Audio input device (built-in mic or external)

Not compatible with:
✗ macOS Big Sur (11) or earlier
✗ Older Intel Macs (pre-2012)

================================================================================
GETTING STARTED
================================================================================

1. INSTALL
   Extract MacSimus-v1.0.zip
   Move MacSimus.app to Applications folder (or desktop)

2. LAUNCH  
   Double-click MacSimus.app
   (Use right-click → Open if you see security warning - see above)

3. GRANT PERMISSIONS
   When prompted, allow:
   ✓ Microphone access (for audio input)
   ✓ Audio access (for system routing)

4. PROCESS AUDIO
   • "App Audio" tab: Process microphone input
   • "System Audio" tab: Process system audio (music, videos)
   • Click "Start Processing" to enable EQ
   • Adjust sliders to hear the effect
   • Try presets for quick adjustments

================================================================================
FEATURES EXPLAINED
================================================================================

🎚️ 12-BAND EQ
   • Each band controls specific frequencies
   • Adjust from -12 dB (reduce) to +12 dB (boost)
   • Real-time visualization shows your curve

💾 PRESETS
   5 Built-In:
   • Flat: Neutral (no coloration)
   • Bass Boost: Enhanced low frequencies
   • Vocal Enhance: Clarity in vocal range  
   • Bright: High-frequency emphasis
   • Warm: Analog-style (bass up, treble down)
   
   Custom: Save unlimited presets with your settings

📊 EQUIPMENT GRAPH
   • Real-time frequency response curve
   • See exactly what the EQ is doing
   • Helps you dial in the perfect sound

⚙️ ADVANCED CONTROLS
   • Q-factor: 0.3 (surgical) to 2.5 (wide) per band
   • Frequency fine-tuning: ±20% adjustment
   • Master gain: -6 to +6 dB overall

🔄 ROUTING
   • App Audio: Just your microphone
   • System Audio: Music apps, videos, games
   • Both: Everything at once

================================================================================
WHAT'S HERE
================================================================================

/ (MacSimus root folder)
├── MacSimus.app          ← The application (double-click to run)
├── INSTALLATION.md       ← Detailed setup guide  
├── RELEASE_NOTES.md      ← Full release information
└── README.txt           ← This file

================================================================================
TROUBLESHOOTING
================================================================================

"App cannot be opened" 
→ See "UNSIGNED BUILD INFO" section above
→ Use right-click → Open method

"I don't see any audio processing"
→ Make sure "Start Processing" button is on
→ Check system audio is routing properly
→ Verify microphone is selected in System Settings

"Presets aren't saving"
→ Make sure you clicked the save button
→ Check Storage & System Settings has app permissions
→ Try restarting the app

"No sound coming through"
→ Check your speakers are on
→ Verify output device is correct
→ Make sure bypass is OFF (System Audio tab)
→ Check volume levels in the EQ app

================================================================================
GETTING HELP  
================================================================================

Need more help?
→ See INSTALLATION.md for detailed setup instructions

Found a bug?
→ Report on GitHub (link in RELEASE_NOTES.md)

Want to modify the app?
→ Source code is available on GitHub
→ See project README for build instructions

================================================================================
LEGAL
================================================================================

MacSimus v1.0
Copyright © 2026 Vishwam Bhara

This is provided as-is for personal use.
See LICENSE in the source repository for details.

================================================================================

Questions? See INSTALLATION.md for more details.
Happy equalization! 🎵
