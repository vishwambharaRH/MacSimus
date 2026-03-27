#include "AudioEngine.h"
#include <iostream>

AudioEngine::AudioEngine() = default;

AudioEngine::~AudioEngine() {
    // DSP cleanup (unique_ptr handles eqEngine)
}

bool AudioEngine::initialize(int requestedSampleRate) {
    sampleRate = requestedSampleRate;
    
    // Create EQ Engine with 12 bands
    eqEngine = std::make_unique<EQEngine>(12, sampleRate);
    
    std::cout << "AudioEngine initialized: " << sampleRate << " Hz, 12-band EQ" << std::endl;
    return true;
}

float AudioEngine::processLeft(float sample) {
    if (!eqEngine) return sample;
    return eqEngine->processLeft(sample);
}

float AudioEngine::processRight(float sample) {
    if (!eqEngine) return sample;
    return eqEngine->processRight(sample);
}

void AudioEngine::setGain(int band, float gainDB) {
    if (eqEngine && band >= 0 && band < 12) {
        eqEngine->setGain(band, gainDB);
    }
}

float AudioEngine::getGain(int band) const {
    if (eqEngine && band >= 0 && band < 12) {
        return eqEngine->getGain(band);
    }
    return 0.0f;
}

int AudioEngine::getSampleRate() const {
    return sampleRate;
}
