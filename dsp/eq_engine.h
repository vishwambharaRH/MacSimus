#pragma once
#include "biquad.h"
#include <vector>
#include <algorithm>

class EQEngine {
public:
    // Constants
    static constexpr float MIN_GAIN_DB = -12.0f;
    static constexpr float MAX_GAIN_DB = 12.0f;
    static constexpr int SMOOTHING_SAMPLES = 512; // Smooth over 512 samples (~11ms at 44.1kHz)

    EQEngine(int bands, float sampleRate)
        : bands(bands), sampleRate(sampleRate) {
        filtersLeft.resize(bands);
        filtersRight.resize(bands);
        freqs.resize(bands);
        gains.resize(bands, 0.0f);
        targetGains.resize(bands, 0.0f);
        smoothedGains.resize(bands, 0.0f);
        gainSmoothingCounters.resize(bands, 0);
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
        // Step 2.2: Clamp gain to safe range
        targetGains[band] = std::clamp(gainDB, MIN_GAIN_DB, MAX_GAIN_DB);
        // Start smoothing from current smoothed value
        if (gainSmoothingCounters[band] == 0) {
            smoothedGains[band] = gains[band];
            // Immediately apply if not smoothing
            gains[band] = targetGains[band];
            updateFilter(band);
        }
        gainSmoothingCounters[band] = SMOOTHING_SAMPLES;
    }

    float process(float sample) {
        // Step 2.1: Update smoothed gains (parameter smoothing)
        // No dynamic allocation here - pre-allocated vectors only
        updateSmoothingProgress();
        
        float out = sample;
        for (auto& f : filtersLeft) {
            out = f.process(out);
        }
        return out;
    }

    float processLeft(float sample) {
        updateSmoothingProgress();
        
        float out = sample;
        for (auto& f : filtersLeft) {
            out = f.process(out);
        }
        return out;
    }

    float processRight(float sample) {
        updateSmoothingProgress();
        
        float out = sample;
        for (auto& f : filtersRight) {
            out = f.process(out);
        }
        return out;
    }

    float getGain(int band) const {
        return gains[band];
    }

private:
    int bands;
    float sampleRate;

    std::vector<Biquad> filtersLeft;
    std::vector<Biquad> filtersRight;
    std::vector<float> freqs;
    std::vector<float> gains;              // Current applied gains
    std::vector<float> targetGains;        // Target gains for smoothing
    std::vector<float> smoothedGains;      // Intermediate smoothed values
    std::vector<int> gainSmoothingCounters; // Progress of smoothing for each band
    std::vector<float> Qs;

    void updateSmoothingProgress() {
        // Advance parameter smoothing for each band
        for (int i = 0; i < bands; ++i) {
            if (gainSmoothingCounters[i] > 0) {
                // Linear interpolation from smoothedGains toward targetGains
                float progress = (float)(SMOOTHING_SAMPLES - gainSmoothingCounters[i]) / SMOOTHING_SAMPLES;
                gains[i] = smoothedGains[i] + (targetGains[i] - smoothedGains[i]) * progress;
                
                gainSmoothingCounters[i]--;
                
                // Update filter when smoothing completes
                if (gainSmoothingCounters[i] == 0) {
                    gains[i] = targetGains[i];
                    updateFilter(i);
                }
            }
        }
    }

    void updateFilters() {
        for (int i = 0; i < bands; ++i) {
            updateFilter(i);
        }
    }

    void updateFilter(int i) {
        filtersLeft[i].setPeakingEQ(sampleRate, freqs[i], Qs[i], gains[i]);
        filtersRight[i].setPeakingEQ(sampleRate, freqs[i], Qs[i], gains[i]);
    }
};