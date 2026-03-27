#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include "AudioEngine.h"
#include <memory>
#include <iostream>

/**
 * AudioEngineWrapper: Objective-C++ wrapper around AudioEngine
 * Bridges C++ audio processing to Swift/Objective-C
 * Handles all AVAudioEngine I/O
 */
@interface AudioEngineWrapper : NSObject {
    std::unique_ptr<AudioEngine> audioEngine;
    AudioComponentInstance audioUnit;
    AUGraph audioGraph;
    BOOL isRunning;
}

- (instancetype)init;
- (BOOL)initialize:(int)sampleRate;
- (BOOL)start;
- (BOOL)stop;

- (void)setGain:(int)band toValue:(float)gainDB;
- (float)getGainForBand:(int)band;

- (BOOL)isRunning;
- (int)getSampleRate;

// Private helper methods
- (float)processLeftSample:(float)sample;
- (float)processRightSample:(float)sample;

@end

// Static callback for audio unit
static OSStatus audioCallback(void* inRefCon,
                              AudioUnitRenderActionFlags* ioActionFlags,
                              const AudioTimeStamp* inTimeStamp,
                              UInt32 inBusNumber,
                              UInt32 inNumberFrames,
                              AudioBufferList* ioData) {
    AudioEngineWrapper* self = (__bridge AudioEngineWrapper*)inRefCon;
    
    // Process audio through the DSP engine
    for (UInt32 i = 0; i < ioData->mNumberBuffers; ++i) {
        AudioBuffer& buffer = ioData->mBuffers[i];
        float* samples = (float*)buffer.mData;
        
        // Process left/right channels
        if (i == 0) {
            // Left channel
            for (UInt32 j = 0; j < inNumberFrames; ++j) {
                samples[j] = [self processLeftSample:samples[j]];
            }
        } else if (i == 1) {
            // Right channel
            for (UInt32 j = 0; j < inNumberFrames; ++j) {
                samples[j] = [self processRightSample:samples[j]];
            }
        }
    }
    
    return noErr;
}

// Implementation
@implementation AudioEngineWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        audioEngine = std::make_unique<AudioEngine>();
        audioUnit = nullptr;
        audioGraph = nullptr;
        isRunning = NO;
    }
    return self;
}

- (BOOL)initialize:(int)sampleRate {
    // Initialize the DSP engine
    if (!audioEngine->initialize(sampleRate)) {
        NSLog(@"Failed to initialize audio DSP engine");
        return NO;
    }
    
    // Set up audio unit for I/O
    AudioComponentDescription desc = {};
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_DefaultOutput;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    AudioComponent component = AudioComponentFindNext(nullptr, &desc);
    if (!component) {
        NSLog(@"Failed to find audio component");
        return NO;
    }
    
    OSStatus result = AudioComponentInstanceNew(component, &audioUnit);
    if (result != noErr) {
        NSLog(@"Failed to create audio unit: %d", (int)result);
        return NO;
    }
    
    // Configure audio format (stereo, 32-bit float)
    AudioStreamBasicDescription format = {};
    format.mSampleRate = sampleRate;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kAudioFormatFlagsNativeFloatPacked;
    format.mBytesPerPacket = 8;
    format.mFramesPerPacket = 1;
    format.mBytesPerFrame = 8;
    format.mChannelsPerFrame = 2;
    format.mBitsPerChannel = 32;
    
    result = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0,
                                  &format,
                                  sizeof(format));
    if (result != noErr) {
        NSLog(@"Failed to set audio format: %d", (int)result);
        return NO;
    }
    
    // Set up render callback
    AURenderCallbackStruct callback;
    callback.inputProc = audioCallback;
    callback.inputProcRefCon = (__bridge void*)self;
    
    result = AudioUnitSetProperty(audioUnit,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &callback,
                                  sizeof(callback));
    if (result != noErr) {
        NSLog(@"Failed to set render callback: %d", (int)result);
        return NO;
    }
    
    // Initialize the audio unit
    result = AudioUnitInitialize(audioUnit);
    if (result != noErr) {
        NSLog(@"Failed to initialize audio unit: %d", (int)result);
        return NO;
    }
    
    NSLog(@"AudioEngineWrapper initialized successfully");
    return YES;
}

- (BOOL)start {
    if (!audioUnit) return NO;
    
    OSStatus result = AudioOutputUnitStart(audioUnit);
    if (result != noErr) {
        NSLog(@"Failed to start audio: %d", (int)result);
        return NO;
    }
    
    isRunning = YES;
    NSLog(@"Audio engine started");
    return YES;
}

- (BOOL)stop {
    if (!audioUnit || !isRunning) return NO;
    
    OSStatus result = AudioOutputUnitStop(audioUnit);
    if (result != noErr) {
        NSLog(@"Failed to stop audio: %d", (int)result);
        return NO;
    }
    
    isRunning = NO;
    NSLog(@"Audio engine stopped");
    return YES;
}

- (void)setGain:(int)band toValue:(float)gainDB {
    if (audioEngine) {
        audioEngine->setGain(band, gainDB);
    }
}

- (float)getGainForBand:(int)band {
    if (audioEngine) {
        return audioEngine->getGain(band);
    }
    return 0.0f;
}

- (BOOL)isRunning {
    return isRunning;
}

- (int)getSampleRate {
    if (audioEngine) {
        return audioEngine->getSampleRate();
    }
    return 0;
}

// Helper methods for audio processing
- (float)processLeftSample:(float)sample {
    if (audioEngine) {
        return audioEngine->processLeft(sample);
    }
    return sample;
}

- (float)processRightSample:(float)sample {
    if (audioEngine) {
        return audioEngine->processRight(sample);
    }
    return sample;
}

- (void)dealloc {
    if (audioUnit) {
        AudioOutputUnitStop(audioUnit);
        AudioComponentInstanceDispose(audioUnit);
    }
}

@end

