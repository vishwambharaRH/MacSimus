import Foundation

/**
 * SystemAudioManager: Manages system-wide audio routing
 * Handles device enumeration and virtual device control
 */
@MainActor
class SystemAudioManager: NSObject, ObservableObject {
    @Published var audioDevices: [AudioDevice] = []
    @Published var selectedOutputDevice: AudioDevice?
    @Published var isSystemWideEnabled = false
    @Published var statusMessage = "System audio not initialized"
    
    static let shared = SystemAudioManager()
    
    private var virtualDevice: VirtualAudioDeviceWrapper?
    private let audioQueue = DispatchQueue(label: "SystemAudioQueue")
    
    struct AudioDevice: Identifiable, Hashable {
        let id: UInt32
        let name: String
        let isInput: Bool
        let isOutput: Bool
        
        var displayName: String {
            let type = (isInput && isOutput) ? "I/O" : (isInput ? "Input" : "Output")
            return "\(name) [\(type)]"
        }
    }
    
    override init() {
        super.init()
        setupVirtualDevice()
    }
    
    private func setupVirtualDevice() {
        audioQueue.async { [weak self] in
            self?.virtualDevice = VirtualAudioDeviceWrapper()
            
            let success = self?.virtualDevice?.initialize(44100) ?? false
            DispatchQueue.main.async {
                if success {
                    self?.statusMessage = "System audio ready"
                    self?.refreshAudioDevices()
                } else {
                    self?.statusMessage = "Failed to initialize system audio"
                }
            }
        }
    }
    
    func refreshAudioDevices() {
        guard let virtualDevice = virtualDevice else {
            statusMessage = "Virtual device not initialized"
            return
        }
        
        audioQueue.async { [weak self] in
            let deviceDicts = virtualDevice.getAudioDevices()
            var devices: [AudioDevice] = []
            
            for dict in deviceDicts {
                if let id = dict["id"] as? NSNumber,
                   let name = dict["name"] as? String,
                   let isInput = dict["isInput"] as? NSNumber,
                   let isOutput = dict["isOutput"] as? NSNumber {
                    
                    let device = AudioDevice(
                        id: id.uint32Value,
                        name: name,
                        isInput: isInput.boolValue,
                        isOutput: isOutput.boolValue
                    )
                    devices.append(device)
                }
            }
            
            DispatchQueue.main.async {
                self?.audioDevices = devices.sorted { $0.name < $1.name }
                
                // Auto-select first output device
                if self?.selectedOutputDevice == nil {
                    self?.selectedOutputDevice = devices.first(where: { $0.isOutput })
                }
            }
        }
    }
    
    func enableSystemWide() {
        guard let virtualDevice = virtualDevice,
              let outputDevice = selectedOutputDevice else {
            statusMessage = "Cannot enable: device not selected"
            return
        }
        
        audioQueue.async { [weak self] in
            let setDevice = virtualDevice.setOutputDevice(outputDevice.id)
            let started = virtualDevice.start()
            
            DispatchQueue.main.async {
                if setDevice && started {
                    self?.isSystemWideEnabled = true
                    self?.statusMessage = "System-wide EQ enabled on \(outputDevice.name)"
                } else {
                    self?.statusMessage = "Failed to enable system-wide audio"
                }
            }
        }
    }
    
    func disableSystemWide() {
        guard let virtualDevice = virtualDevice else {
            statusMessage = "Virtual device not initialized"
            return
        }
        
        audioQueue.async { [weak self] in
            virtualDevice.stop()
            
            DispatchQueue.main.async {
                self?.isSystemWideEnabled = false
                self?.statusMessage = "System-wide EQ disabled"
            }
        }
    }
    
    func setBypass(_ enabled: Bool) {
        guard let virtualDevice = virtualDevice else { return }
        
        audioQueue.async {
            virtualDevice.setBypass(enabled)
        }
        
        statusMessage = enabled ? "EQ bypassed" : "EQ active"
    }
    
    func setGain(band: Int, value: Float) {
        guard let virtualDevice = virtualDevice else { return }
        
        audioQueue.async {
            virtualDevice.setGain(Int32(band), toValue: value)
        }
    }
}
