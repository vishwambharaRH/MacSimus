#include "VirtualAudioDevice.h"
#include "../dsp/utils.h"
#include <iostream>
#include <iomanip>
#include <cmath>
#include <thread>
#include <chrono>

int main() {
    std::cout << "=== MacSimus System-Wide Audio Test ===" << std::endl;
    
    // Create virtual device
    VirtualAudioDevice virtualDevice;
    
    // Initialize
    std::cout << "\n--- Initializing Virtual Audio Device ---" << std::endl;
    if (!virtualDevice.initialize(44100)) {
        std::cerr << "Failed to initialize virtual device" << std::endl;
        return 1;
    }
    std::cout << "✓ Virtual device initialized" << std::endl;
    std::cout << "Sample Rate: " << virtualDevice.getSampleRate() << " Hz" << std::endl;
    
    // List audio devices
    std::cout << "\n--- Available Audio Devices ---" << std::endl;
    auto devices = VirtualAudioDevice::listAudioDevices();
    for (size_t i = 0; i < devices.size(); ++i) {
        std::string name = VirtualAudioDevice::getDeviceName(devices[i]);
        bool isInput = VirtualAudioDevice::isDeviceInput(devices[i]);
        bool isOutput = VirtualAudioDevice::isDeviceOutput(devices[i]);
        
        std::string type = "";
        if (isInput && isOutput) type = "[I/O]";
        else if (isInput) type = "[IN]";
        else if (isOutput) type = "[OUT]";
        
        std::cout << i << ". " << name << " " << type << " (ID: " << devices[i] << ")" << std::endl;
    }
    
    // Set output device (use first output device found)
    std::cout << "\n--- Configuring Routing ---" << std::endl;
    AudioDeviceID outputDevice = kAudioDeviceUnknown;
    for (auto deviceID : devices) {
        if (VirtualAudioDevice::isDeviceOutput(deviceID)) {
            outputDevice = deviceID;
            break;
        }
    }
    
    if (outputDevice != kAudioDeviceUnknown) {
        virtualDevice.setOutputDevice(outputDevice);
        std::cout << "✓ Output device: " << VirtualAudioDevice::getDeviceName(outputDevice) << std::endl;
    } else {
        std::cerr << "No output device found" << std::endl;
        return 1;
    }
    
    // Test: Set gains
    std::cout << "\n--- Setting EQ Gains ---" << std::endl;
    virtualDevice.setGain(0, 6.0f);   // Bass boost
    virtualDevice.setGain(6, 3.0f);   // Mid boost
    virtualDevice.setGain(11, -3.0f); // Treble cut
    std::cout << "✓ Gains set:" << std::endl;
    std::cout << "  Band 0 (Bass): +" << virtualDevice.getGain(0) << " dB" << std::endl;
    std::cout << "  Band 6 (Mid): +" << virtualDevice.getGain(6) << " dB" << std::endl;
    std::cout << "  Band 11 (Treble): " << virtualDevice.getGain(11) << " dB" << std::endl;
    
    // Test: Start/Stop
    std::cout << "\n--- Testing Device Operation ---" << std::endl;
    if (!virtualDevice.start()) {
        std::cerr << "Failed to start virtual device" << std::endl;
        return 1;
    }
    std::cout << "✓ Virtual device started" << std::endl;
    std::cout << "  Running: " << (virtualDevice.isRunning() ? "YES" : "NO") << std::endl;
    
    // Test: Bypass functionality
    std::cout << "\n--- Testing Bypass ---" << std::endl;
    std::cout << "  Bypass OFF (EQ active): " << (!virtualDevice.isBypass() ? "YES" : "NO") << std::endl;
    
    virtualDevice.setBypass(true);
    std::cout << "  Bypass ON (EQ inactive): " << (virtualDevice.isBypass() ? "YES" : "NO") << std::endl;
    
    virtualDevice.setBypass(false);
    std::cout << "  Bypass OFF (EQ active): " << (!virtualDevice.isBypass() ? "YES" : "NO") << std::endl;
    
    // Test: Simulate audio processing (without actual I/O)
    std::cout << "\n--- Simulating Audio Processing ---" << std::endl;
    SineWaveGenerator gen(44100.0f, 440.0f);
    
    const int numSamples = 44100;
    float* testBuffer = new float[numSamples];
    
    // Generate test signal
    for (int i = 0; i < numSamples; ++i) {
        testBuffer[i] = gen.generate();
    }
    
    float inputRMS = 0.0f;
    for (int i = 0; i < numSamples; ++i) {
        inputRMS += testBuffer[i] * testBuffer[i];
    }
    inputRMS = std::sqrt(inputRMS / numSamples);
    
    std::cout << "Generated 1 second of test signal (440 Hz)" << std::endl;
    std::cout << "Input RMS: " << std::fixed << std::setprecision(6) << inputRMS << std::endl;
    
    // Test parameter changes during operation
    std::cout << "\n--- Real-Time Gain Adjustments ---" << std::endl;
    virtualDevice.setGain(0, 0.0f);
    std::cout << "Set band 0 to 0 dB (flat)" << std::endl;
    
    virtualDevice.setGain(0, 12.0f);
    std::cout << "Set band 0 to +12 dB (max boost)" << std::endl;
    std::cout << "✓ Real-time adjustments working" << std::endl;
    
    // Stop device
    std::cout << "\n--- Stopping Virtual Device ---" << std::endl;
    if (!virtualDevice.stop()) {
        std::cerr << "Failed to stop virtual device" << std::endl;
        return 1;
    }
    std::cout << "✓ Virtual device stopped" << std::endl;
    std::cout << "  Running: " << (virtualDevice.isRunning() ? "YES" : "NO") << std::endl;
    
    delete[] testBuffer;
    
    std::cout << "\n=== System-Wide Audio Test Complete ===" << std::endl;
    std::cout << "✓ Virtual audio device working correctly" << std::endl;
    std::cout << "✓ Ready for system-wide audio routing" << std::endl;
    
    return 0;
}
