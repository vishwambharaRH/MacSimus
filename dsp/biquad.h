#pragma once
#include <cmath>

class Biquad {
public:
    Biquad() { reset(); }

    void reset() {
        z1 = z2 = 0.0f;
    }

    void setPeakingEQ(float sampleRate, float freq, float Q, float gainDB) {
        float A = pow(10.0f, gainDB / 40.0f);
        float omega = 2.0f * M_PI * freq / sampleRate;
        float alpha = sin(omega) / (2.0f * Q);

        float cosw = cos(omega);

        float b0 = 1 + alpha * A;
        float b1 = -2 * cosw;
        float b2 = 1 - alpha * A;
        float a0 = 1 + alpha / A;
        float a1 = -2 * cosw;
        float a2 = 1 - alpha / A;

        // Normalize
        this->b0 = b0 / a0;
        this->b1 = b1 / a0;
        this->b2 = b2 / a0;
        this->a1 = a1 / a0;
        this->a2 = a2 / a0;
    }

    inline float process(float input) {
        float output = b0 * input + z1;
        z1 = b1 * input - a1 * output + z2;
        z2 = b2 * input - a2 * output;
        return output;
    }

private:
    float b0 = 1, b1 = 0, b2 = 0;
    float a1 = 0, a2 = 0;

    float z1 = 0, z2 = 0;
};