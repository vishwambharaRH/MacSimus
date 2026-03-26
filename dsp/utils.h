#pragma once
#include <cmath>

class SineWaveGenerator {
public:
    SineWaveGenerator(float sampleRate, float frequency)
        : sampleRate(sampleRate), frequency(frequency), phase(0.0f) {}

    float generate() {
        float sample = sin(2.0f * M_PI * phase);
        phase += frequency / sampleRate;
        if (phase >= 1.0f) {
            phase -= 1.0f;
        }
        return sample;
    }

    void reset() {
        phase = 0.0f;
    }

    void setFrequency(float newFrequency) {
        frequency = newFrequency;
    }

private:
    float sampleRate;
    float frequency;
    float phase;
};
