#include <iostream>
#include "eq_engine.h"

int main() {
    EQEngine eq(12, 44100.0f);

    // Boost mid band
    eq.setGain(5, 6.0f);

    // Simulated signal
    for (int i = 0; i < 100; ++i) {
        float input = (i % 50) / 50.0f; // dummy waveform
        float output = eq.process(input);

        std::cout << output << std::endl;
    }

    return 0;
}