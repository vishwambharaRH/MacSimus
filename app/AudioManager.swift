import Foundation
import AVFoundation

/**
 * AudioManager: Manages audio engine lifecycle and state
 * Bridges between SwiftUI and the C++ audio engine
 */
@MainActor
class AudioManager: NSObject, ObservableObject {
    @Published var isRunning = false
    @Published var gains: [Float] = Array(repeating: 0.0, count: 12)
    @Published var statusMessage = "Ready"
    
    static let shared = AudioManager()
    
    private var audioEngine: AudioEngineWrapper?
    private let audioQueue = DispatchQueue(label: "AudioEngineQueue")
    
    override init() {
        super.init()
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioQueue.async { [weak self] in
            self?.audioEngine = AudioEngineWrapper()
            
            // Request microphone permission
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.initializeAudioEngine()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.statusMessage = "Microphone permission denied"
                    }
                }
            }
        }
    }
    
    private func initializeAudioEngine() {
        guard let engine = audioEngine else { return }
        
        let success = engine.initialize(44100)
        if success {
            statusMessage = "Audio engine initialized"
        } else {
            statusMessage = "Failed to initialize audio engine"
        }
    }
    
    func start() {
        guard let engine = audioEngine else {
            statusMessage = "Audio engine not initialized"
            return
        }
        
        audioQueue.async { [weak self] in
            let success = engine.start()
            DispatchQueue.main.async {
                self?.isRunning = success
                self?.statusMessage = success ? "Audio processing started" : "Failed to start audio"
            }
        }
    }
    
    func stop() {
        guard let engine = audioEngine else { return }
        
        audioQueue.async { [weak self] in
            let success = engine.stop()
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.statusMessage = "Audio processing stopped"
            }
        }
    }
    
    func setGain(band: Int, value: Float) {
        guard band >= 0 && band < 12 else { return }
        guard let engine = audioEngine else { return }
        
        gains[band] = value
        
        audioQueue.async {
            engine.setGain(Int32(band), toValue: value)
        }
    }
    
    func resetToFlat() {
        for i in 0..<12 {
            setGain(band: i, value: 0.0)
        }
        statusMessage = "Reset to flat response"
    }
    
    func applyBassBoost() {
        // Boost low bands
        setGain(band: 0, value: 6.0)
        setGain(band: 1, value: 4.0)
        setGain(band: 2, value: 2.0)
        statusMessage = "Applied bass boost preset"
    }
    
    func applyVocalEnhance() {
        // Boost mid bands for vocal clarity
        setGain(band: 3, value: 3.0)
        setGain(band: 4, value: 4.0)
        setGain(band: 5, value: 3.0)
        statusMessage = "Applied vocal enhance preset"
    }
}
