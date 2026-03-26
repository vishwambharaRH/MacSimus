#pragma once
#include "biquad.h"
#include <vector>

class EQEngine {
public:
    EQEngine(int bands, float sampleRate)
        : bands(bands), sampleRate(sampleRate) {
        filters.resize(bands);
        freqs.resize(bands);
        gains.resize(bands, 0.0f);
        Qs.resize(bands, 1.0f);

        // Default frequency distribution (log spaced)
        float minFreq = 20.0f;
        float maxFreq = 20000.0f;

        for (int i = 0; i < bands; ++i) {
            float t = (float)i / (bands - 1);
            freqs[i] = minFreq * pow(maxFreq / minFreq, t);
        }

        updateFilters();
    }

    void setGain(int band, float gainDB) {
        gains[band] = gainDB;
        updateFilter(band);
    }

    float process(float sample) {
        float out = sample;
        for (auto& f : filters) {
            out = f.process(out);
        }
        return out;
    }

private:
    int bands;
    float sampleRate;

    std::vector<Biquad> filters;
    std::vector<float> freqs;
    std::vector<float> gains;
    std::vector<float> Qs;

    void updateFilters() {
        for (int i = 0; i < bands; ++i) {
            updateFilter(i);
        }
    }

    void updateFilter(int i) {
        filters[i].setPeakingEQ(sampleRate, freqs[i], Qs[i], gains[i]);
    }
};