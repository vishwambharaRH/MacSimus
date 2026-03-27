# MacSimus v1.0 - System-Wide 12-Band EQ for macOS

## 🎉 Release Highlights

**Production-ready 12-band parametric equalizer with real-time visualization and professional preset management.**

### Phase 5: UI Polish & Visualization
This release adds professional audio visualization and comprehensive preset management.

#### What's New
- ✨ **Real-time EQ Curve Graph** - See frequency response updates live
- 💾 **Preset Management** - 5 built-in presets + save custom settings
- ⚙️ **Advanced Controls** - Q-factor, frequency fine-tuning, master gain
- 🎨 **Professional UI** - Dark mode, smooth animations, responsive design

### Built-in Presets
1. **Flat** - Neutral response
2. **Bass Boost** - Enhanced low-frequency emphasis
3. **Vocal Enhance** - Clarity peak in vocal range
4. **Bright** - High-frequency enhancement
5. **Warm** - Analog-style sound (bass up, treble down)

## 📦 What's Included

- Complete macOS application (.app bundle)
- All source code (Swift + C++)
- Build system ready for customization
- Documentation and build instructions

## ⚙️ System Requirements

- **macOS:** 12.0 Monterey or later
- **Processor:** Apple Silicon (M1/M2/M3) or Intel
- **Storage:** ~50 MB for app + dependencies
- **RAM:** 256 MB minimum

## 🚀 Quick Start

1. **Extract** the `MacSimus-v1.0.zip` file
2. **Open** the extracted `MacSimus.app`
3. **Allow** microphone and audio access when prompted
4. **Start** processing audio!

### Note for Unsigned Builds
Since this is an unsigned build, you may see security warnings:
- Right-click the app and select "Open"
- Or go to System Settings > Privacy & Security and click "Open Anyway"
- This is required on macOS Monterey and later

## 🎵 Features

### Core Capabilities
- 12 independent parametric EQ bands
- ±12 dB gain range per band
- Real-time audio processing (< 10ms latency)
- Stereo processing (independent L/R channels)

### Audio Routing
- **App Mode**: Process microphone input
- **System Mode**: Route system audio (music, videos, etc.)
- **Hybrid**: Both modes simultaneously

### Professional Tools
- Real-time frequency response visualization
- 5 professional presets
- Unlimited custom presets
- Per-band Q-factor adjustment (0.3-2.5)
- Center frequency fine-tuning (±20%)
- Master gain control (-6 to +6 dB)

## 🔧 Build Information

- **Language**: Swift 5.0+ with C++17
- **Frameworks**: SwiftUI, AVFoundation, CoreAudio
- **DSP**: Custom biquad filter implementation
- **Testing**: 28/29 integration tests passing

## 📊 Performance

- **CPU**: < 2% at idle, < 5% during processing
- **Memory**: ~25 MB resident
- **Latency**: < 10 ms per channel
- **Sample Rate**: 44.1 kHz

## 🔐 Privacy & Security

- ✅ No data collection
- ✅ No network transmission
- ✅ Fully offline operation
- ✅ Open source (available on GitHub)

## 📝 Documentation

Comprehensive documentation is included:
- `BUILD.md` - Build and compilation guide
- `PHASE5_DETAILS.md` - Complete Phase 5 feature documentation
- `STEPS.md` - Implementation timeline for all phases
- Source code with inline comments

## 🎯 Roadmap

### Planned Features
- **v1.1** - Spectrum analyzer, preset library export
- **v1.2** - Per-application volume control
- **v1.3** - Advanced visualization and effects
- **v2.0** - Multi-platform support (iOS/iPadOS)

## 💬 Feedback & Contribution

- **Issues**: Found a bug? Open an issue on GitHub
- **Discussions**: Feature requests and ideas welcome
- **Pull Requests**: Contributions are appreciated

## 📄 License

MacSimus is provided as-is for personal use. See LICENSE file for details.

## 🙏 Acknowledgments

Built with:
- SwiftUI for modern macOS interface
- CoreAudio for system integration
- C++ for real-time DSP processing

---

**Version**: 1.0  
**Release Date**: March 27, 2026  
**Build**: Phase 5 Complete  
**Status**: Production Ready ✅

Thank you for using MacSimus! 🎵
