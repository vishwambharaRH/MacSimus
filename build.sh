#!/bin/bash
# MacSimus Build Script

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"

echo "======================================"
echo "MacSimus - Build Script"
echo "======================================"

# Create build directory
if [ ! -d "$BUILD_DIR" ]; then
    echo "Creating build directory..."
    mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR"

# Run CMake
echo ""
echo "Configuring build..."
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build
echo ""
echo "Building MacSimus components..."
cmake --build . --config Release --parallel $(sysctl -n hw.ncpu)

echo ""
echo "======================================"
echo "✓ Build complete!"
echo "======================================"
echo ""
echo "Built artifacts:"
echo "  - DSP Test: $BUILD_DIR/dsp/dsp_test"
echo "  - Audio Test: $BUILD_DIR/audio/audio_test"
echo ""
echo "Next steps:"
echo "  1. Open MacSimus.xcodeproj in Xcode"
echo "  2. Build the SwiftUI app"
echo "  3. Run on macOS"
echo ""
