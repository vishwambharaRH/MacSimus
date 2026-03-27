# Build Guide - MacSimus

## Prerequisites

- macOS 11.0 or later
- Xcode 13+ with Command Line Tools
- CMake 3.15+ (install via `brew install cmake`)

## Build Options

### Option 1: CMake Build (Audio & DSP components)

```bash
cd MacSimus
chmod +x build.sh
./build.sh
```

This will:
1. Create a `build/` directory
2. Compile DSP library
3. Compile Audio Engine (C++)
4. Compile Audio Wrapper (Objective-C++)
5. Build test binaries

### Option 2: Xcode Project

To create an Xcode project from CMake:

```bash
cd MacSimus/build
cmake .. -G Xcode
open MacSimus.xcodeproj
```

Then build in Xcode.

## Running Tests

### DSP Core Test
```bash
./build/dsp/dsp_test
```

Expected output: All Phase 2 tests pass with stable RMS values.

### Audio Engine Test
```bash
./build/audio/audio_test
```

This will:
- Initialize the audio engine
- Test gain control
- Start real-time audio processing
- Test parameter smoothing
- Run for ~5 seconds of audio

## Building the macOS App

### Step 1: Set up Xcode Project

```bash
cd MacSimus
open MacSimus.xcodeproj
```

If the project doesn't exist yet, create it:
```bash
# Create new SwiftUI app
xcode-select --install  # if needed
```

### Step 2: Configure Project

In Xcode:
1. Set the Bridging Header: 
   - Build Settings → Bridging Header → `MacSimus-Bridging-Header.h`
2. Add Source Files:
   - Drag `/app/*.swift` files into Xcode
   - Drag `/audio/*.cpp` and `/audio/*.mm` files into Xcode
   - Drag `/dsp/*.h` files into Xcode (as headers)
3. Link Frameworks:
   - Build Phases → Link Binary With Libraries
   - Add: AVFoundation, CoreAudio, AudioToolbox

### Step 3: Build and Run

```bash
# Build
Cmd+B

# Run
Cmd+R
```

## Project Structure After Build

```
MacSimus/
├── build/                 # CMake build output
│   ├── dsp/
│   │   └── dsp_test      # DSP test binary
│   └── audio/
│       └── audio_test    # Audio test binary
├── dsp/                   # C++ DSP core (completed)
│   ├── biquad.h
│   ├── eq_engine.h
│   ├── utils.h
│   └── main.cpp
├── audio/                 # C++ Audio Engine (completed)
│   ├── AudioEngine.h
│   ├── AudioEngine.cpp
│   ├── AudioEngineWrapper.mm
│   └── test_audio.cpp
├── app/                   # SwiftUI App (completed)
│   ├── MacSimusApp.swift
│   ├── ContentView.swift
│   ├── AudioManager.swift
│   ├── EQBandView.swift
│   └── AudioManager.swift
├── MacSimus-Bridging-Header.h
├── CMakeLists.txt
└── build.sh
```

## Troubleshooting

### "Bridging header not found"
- Check Xcode Build Settings: `Bridging Header` points to `MacSimus-Bridging-Header.h`

### Audio engine won't initialize
- Ensure AVFoundation is linked in Build Phases
- Check System Preferences → Security & Privacy → Microphone (if needed)

### CMake not found
```bash
brew install cmake
export PATH="/usr/local/bin:$PATH"
```

### Permission denied on build.sh
```bash
chmod +x build.sh
```

## Next Steps

1. ✅ DSP Core Complete (Phase 1-2)
2. ✅ Audio Pipeline Started (Phase 3)
3. ⏳ Complete Xcode Project Setup
4. ⏳ System-Wide Audio Routing (Phase 4)
5. ⏳ UI Polish (Phase 5)
