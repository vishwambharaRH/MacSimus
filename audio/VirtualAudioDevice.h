#pragma once

#include <CoreAudio/CoreAudio.h>
#include <AudioToolbox/AudioToolbox.h>
#include "../dsp/eq_engine.h"
#include <memory>
#include <vector>
#include <cstdint>

// Forward declare static callback
static OSStatus inputDeviceIOProc(AudioDeviceID inDevice,
                                  const AudioTimeStamp* inNow,
                                  const AudioBufferList* inInputData,
                                  const AudioTimeStamp* inInputTime,
                                  AudioBufferList* outOutputData,
                                  const AudioTimeStamp* inOutputTime,
                                  void* inClientData);

/**
 * VirtualAudioDevice: Manages a virtual audio device for system-wide audio processing
 * 
 * This class:
 * - Creates/manages a virtual audio device
 * - Intercepts system audio
 * - Processes through EQ engine
 * - Outputs to physical device
 * 
 * Uses CoreAudio HAL for device management
 */
class VirtualAudioDevice {
public:
    VirtualAudioDevice();
    ~VirtualAudioDevice();

    // Device lifecycle
    bool initialize(int sampleRate = 44100);
    bool start();
    bool stop();
    
    // Control
    void setBypass(bool shouldBypass);
    bool isBypass() const;
    bool isRunning() const;
    
    // Routing
    bool setInputDevice(AudioDeviceID deviceID);
    bool setOutputDevice(AudioDeviceID deviceID);
    
    AudioDeviceID getVirtualDeviceID() const;
    AudioDeviceID getInputDeviceID() const;
    AudioDeviceID getOutputDeviceID() const;
    
    // DSP Control
    void setGain(int band, float gainDB);
    float getGain(int band) const;
    int getSampleRate() const;
    
    // Get system audio devices
    static std::vector<AudioDeviceID> listAudioDevices();
    static std::string getDeviceName(AudioDeviceID deviceID);
    static bool isDeviceInput(AudioDeviceID deviceID);
    static bool isDeviceOutput(AudioDeviceID deviceID);
    
    // Audio processing (public for callback access)
    OSStatus processAudio(const AudioBufferList* inInputData,
                         AudioBufferList* outOutputData);
    
    // Static callback access (for inputDeviceIOProc)
    static VirtualAudioDevice* instancePtr;
    
private:
    // CoreAudio device IDs
    AudioDeviceID virtualDeviceID = kAudioDeviceUnknown;
    AudioDeviceID inputDeviceID = kAudioDeviceUnknown;
    AudioDeviceID outputDeviceID = kAudioDeviceUnknown;
    
    int sampleRate = 44100;
    bool running = false;
    bool bypass = false;
    
    // DSP Engine
    std::unique_ptr<EQEngine> eqEngine;
};
