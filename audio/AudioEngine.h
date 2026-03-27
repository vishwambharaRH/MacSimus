#pragma once

#include "../dsp/eq_engine.h"
#include <memory>
#include <cstdint>

/**
 * AudioEngine: Simple DSP processor wrapper for audio
 * Note: Actual macOS audio I/O is handled in AudioEngineWrapper.mm
 * This class is pure C++ for cross-platform DSP processing
 */
class AudioEngine {
public:
    AudioEngine();
    ~AudioEngine();

    // Initialize DSP engine
    bool initialize(int sampleRate = 44100);
    
    // DSP Control
    void setGain(int band, float gainDB);
    float getGain(int band) const;
    
    // Process audio
    float processLeft(float sample);
    float processRight(float sample);
    
    // Status
    int getSampleRate() const;
    
private:
    int sampleRate = 44100;

    // DSP Engine
    std::unique_ptr<EQEngine> eqEngine;
};
