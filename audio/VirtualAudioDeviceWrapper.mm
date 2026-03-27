#import <Foundation/Foundation.h>
#include "VirtualAudioDevice.h"
#include <memory>

/**
 * VirtualAudioDeviceWrapper: Objective-C++ wrapper for VirtualAudioDevice
 * Bridges C++ virtual device to Swift
 */
@interface VirtualAudioDeviceWrapper : NSObject

- (instancetype)init;
- (BOOL)initialize:(int)sampleRate;
- (BOOL)start;
- (BOOL)stop;

- (void)setBypass:(BOOL)shouldBypass;
- (BOOL)isBypass;
- (BOOL)isRunning;

- (NSArray<NSDictionary *> *)getAudioDevices;
- (BOOL)setInputDevice:(UInt32)deviceID;
- (BOOL)setOutputDevice:(UInt32)deviceID;

- (void)setGain:(int)band toValue:(float)gainDB;
- (float)getGainForBand:(int)band;

@end

@implementation VirtualAudioDeviceWrapper {
    std::unique_ptr<VirtualAudioDevice> virtualDevice;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        virtualDevice = std::make_unique<VirtualAudioDevice>();
    }
    return self;
}

- (BOOL)initialize:(int)sampleRate {
    return virtualDevice->initialize(sampleRate);
}

- (BOOL)start {
    return virtualDevice->start();
}

- (BOOL)stop {
    return virtualDevice->stop();
}

- (void)setBypass:(BOOL)shouldBypass {
    virtualDevice->setBypass(shouldBypass);
}

- (BOOL)isBypass {
    return virtualDevice->isBypass();
}

- (BOOL)isRunning {
    return virtualDevice->isRunning();
}

- (NSArray<NSDictionary *> *)getAudioDevices {
    NSMutableArray *devices = [NSMutableArray array];
    
    auto deviceIDs = VirtualAudioDevice::listAudioDevices();
    for (auto deviceID : deviceIDs) {
        std::string name = VirtualAudioDevice::getDeviceName(deviceID);
        BOOL isInput = VirtualAudioDevice::isDeviceInput(deviceID);
        BOOL isOutput = VirtualAudioDevice::isDeviceOutput(deviceID);
        
        NSDictionary *device = @{
            @"id": @(deviceID),
            @"name": [NSString stringWithUTF8String:name.c_str()],
            @"isInput": @(isInput),
            @"isOutput": @(isOutput)
        };
        [devices addObject:device];
    }
    
    return devices;
}

- (BOOL)setInputDevice:(UInt32)deviceID {
    return virtualDevice->setInputDevice(deviceID);
}

- (BOOL)setOutputDevice:(UInt32)deviceID {
    return virtualDevice->setOutputDevice(deviceID);
}

- (void)setGain:(int)band toValue:(float)gainDB {
    virtualDevice->setGain(band, gainDB);
}

- (float)getGainForBand:(int)band {
    return virtualDevice->getGain(band);
}

@end
