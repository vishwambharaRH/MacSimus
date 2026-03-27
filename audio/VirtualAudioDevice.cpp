#include "VirtualAudioDevice.h"
#include <iostream>
#include <cstring>

// Global instance for static callback
VirtualAudioDevice* VirtualAudioDevice::instancePtr = nullptr;

// Static callback wrapper
static OSStatus inputDeviceIOProc(AudioDeviceID inDevice,
                                  const AudioTimeStamp* inNow,
                                  const AudioBufferList* inInputData,
                                  const AudioTimeStamp* inInputTime,
                                  AudioBufferList* outOutputData,
                                  const AudioTimeStamp* inOutputTime,
                                  void* inClientData) {
    if (VirtualAudioDevice::instancePtr) {
        return VirtualAudioDevice::instancePtr->processAudio(inInputData, outOutputData);
    }
    return noErr;
}

VirtualAudioDevice::VirtualAudioDevice() {
    instancePtr = this;
}

VirtualAudioDevice::~VirtualAudioDevice() {
    stop();
    instancePtr = nullptr;
}

bool VirtualAudioDevice::initialize(int requestedSampleRate) {
    sampleRate = requestedSampleRate;
    
    // Create EQ Engine
    eqEngine = std::make_unique<EQEngine>(12, sampleRate);
    
    // Get default output device (will be wrapped by virtual device)
    AudioDeviceID defaultOutput = kAudioDeviceUnknown;
    UInt32 size = sizeof(defaultOutput);
    AudioObjectPropertyAddress address = {
        kAudioHardwarePropertyDefaultOutputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    
    OSStatus result = AudioObjectGetPropertyData(kAudioObjectSystemObject,
                                                 &address,
                                                 0,
                                                 nullptr,
                                                 &size,
                                                 &defaultOutput);
    if (result != noErr) {
        std::cerr << "Failed to get default output device: " << result << std::endl;
        return false;
    }
    
    outputDeviceID = defaultOutput;
    std::cout << "VirtualAudioDevice initialized: " << sampleRate << " Hz" << std::endl;
    std::cout << "Output device: " << getDeviceName(outputDeviceID) << std::endl;
    
    return true;
}

bool VirtualAudioDevice::start() {
    if (eqEngine && outputDeviceID != kAudioDeviceUnknown) {
        running = true;
        std::cout << "Virtual audio device started" << std::endl;
        return true;
    }
    return false;
}

bool VirtualAudioDevice::stop() {
    running = false;
    std::cout << "Virtual audio device stopped" << std::endl;
    return true;
}

OSStatus VirtualAudioDevice::processAudio(const AudioBufferList* inInputData,
                                          AudioBufferList* outOutputData) {
    if (!running || bypass || !eqEngine) {
        // Passthrough
        if (inInputData && outOutputData) {
            for (UInt32 i = 0; i < outOutputData->mNumberBuffers; ++i) {
                if (i < inInputData->mNumberBuffers) {
                    std::memcpy(outOutputData->mBuffers[i].mData,
                               inInputData->mBuffers[i].mData,
                               inInputData->mBuffers[i].mDataByteSize);
                }
            }
        }
        return noErr;
    }
    
    // Process through EQ
    if (inInputData && outOutputData) {
        for (UInt32 i = 0; i < outOutputData->mNumberBuffers && i < inInputData->mNumberBuffers; ++i) {
            float* input = (float*)inInputData->mBuffers[i].mData;
            float* output = (float*)outOutputData->mBuffers[i].mData;
            UInt32 numSamples = inInputData->mBuffers[i].mDataByteSize / sizeof(float);
            
            // Process left/right channels
            if (i == 0) {
                // Left channel
                for (UInt32 j = 0; j < numSamples; ++j) {
                    output[j] = eqEngine->processLeft(input[j]);
                }
            } else if (i == 1) {
                // Right channel
                for (UInt32 j = 0; j < numSamples; ++j) {
                    output[j] = eqEngine->processRight(input[j]);
                }
            } else {
                // Copy additional channels as-is
                std::memcpy(output, input, inInputData->mBuffers[i].mDataByteSize);
            }
        }
    }
    
    return noErr;
}

void VirtualAudioDevice::setBypass(bool shouldBypass) {
    bypass = shouldBypass;
    std::cout << "Virtual device bypass: " << (bypass ? "ON" : "OFF") << std::endl;
}

bool VirtualAudioDevice::isBypass() const {
    return bypass;
}

bool VirtualAudioDevice::isRunning() const {
    return running;
}

bool VirtualAudioDevice::setInputDevice(AudioDeviceID deviceID) {
    inputDeviceID = deviceID;
    std::cout << "Input device set to: " << getDeviceName(deviceID) << std::endl;
    return true;
}

bool VirtualAudioDevice::setOutputDevice(AudioDeviceID deviceID) {
    outputDeviceID = deviceID;
    std::cout << "Output device set to: " << getDeviceName(deviceID) << std::endl;
    return true;
}

AudioDeviceID VirtualAudioDevice::getVirtualDeviceID() const {
    return virtualDeviceID;
}

AudioDeviceID VirtualAudioDevice::getInputDeviceID() const {
    return inputDeviceID;
}

AudioDeviceID VirtualAudioDevice::getOutputDeviceID() const {
    return outputDeviceID;
}

void VirtualAudioDevice::setGain(int band, float gainDB) {
    if (eqEngine && band >= 0 && band < 12) {
        eqEngine->setGain(band, gainDB);
    }
}

float VirtualAudioDevice::getGain(int band) const {
    if (eqEngine && band >= 0 && band < 12) {
        return eqEngine->getGain(band);
    }
    return 0.0f;
}

int VirtualAudioDevice::getSampleRate() const {
    return sampleRate;
}

// Static utility methods
std::vector<AudioDeviceID> VirtualAudioDevice::listAudioDevices() {
    std::vector<AudioDeviceID> devices;
    
    AudioObjectPropertyAddress address = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    
    UInt32 size = 0;
    OSStatus result = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject,
                                                     &address,
                                                     0,
                                                     nullptr,
                                                     &size);
    if (result != noErr) return devices;
    
    UInt32 count = size / sizeof(AudioDeviceID);
    AudioDeviceID* deviceIDs = new AudioDeviceID[count];
    
    result = AudioObjectGetPropertyData(kAudioObjectSystemObject,
                                       &address,
                                       0,
                                       nullptr,
                                       &size,
                                       deviceIDs);
    if (result == noErr) {
        for (UInt32 i = 0; i < count; ++i) {
            devices.push_back(deviceIDs[i]);
        }
    }
    
    delete[] deviceIDs;
    return devices;
}

std::string VirtualAudioDevice::getDeviceName(AudioDeviceID deviceID) {
    char name[256];
    UInt32 size = sizeof(name);
    
    AudioObjectPropertyAddress address = {
        kAudioObjectPropertyName,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    
    CFStringRef cfName = nullptr;
    size = sizeof(cfName);
    OSStatus result = AudioObjectGetPropertyData(deviceID,
                                                 &address,
                                                 0,
                                                 nullptr,
                                                 &size,
                                                 &cfName);
    
    std::string deviceName = "Unknown";
    if (result == noErr && cfName) {
        CFIndex length = CFStringGetLength(cfName);
        if (length < 256) {
            CFStringGetCString(cfName, name, sizeof(name), kCFStringEncodingUTF8);
            deviceName = name;
        }
        CFRelease(cfName);
    }
    
    return deviceName;
}

bool VirtualAudioDevice::isDeviceInput(AudioDeviceID deviceID) {
    AudioObjectPropertyAddress address = {
        kAudioDevicePropertyStreams,
        kAudioObjectPropertyScopeInput,
        kAudioObjectPropertyElementMain
    };
    
    UInt32 size = 0;
    OSStatus result = AudioObjectGetPropertyDataSize(deviceID, &address, 0, nullptr, &size);
    return (result == noErr && size > 0);
}

bool VirtualAudioDevice::isDeviceOutput(AudioDeviceID deviceID) {
    AudioObjectPropertyAddress address = {
        kAudioDevicePropertyStreams,
        kAudioObjectPropertyScopeOutput,
        kAudioObjectPropertyElementMain
    };
    
    UInt32 size = 0;
    OSStatus result = AudioObjectGetPropertyDataSize(deviceID, &address, 0, nullptr, &size);
    return (result == noErr && size > 0);
}
