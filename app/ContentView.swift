import SwiftUI

/**
 * ContentView: Main UI for MacSimus EQ with app and system-wide modes
 */
struct ContentView: View {
    @StateObject private var audioManager = AudioManager.shared
    @State private var selectedTab = 0
    
    // Frequency labels for 12 bands (log-spaced from 20 Hz to 20 kHz)
    let frequencies = [
        "20 Hz", "35 Hz", "61 Hz", "106 Hz",
        "185 Hz", "320 Hz", "560 Hz", "970 Hz",
        "1.7 kHz", "2.9 kHz", "5.1 kHz", "8.8 kHz"
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("MacSimus")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("12-Band System-Wide EQ for macOS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Tab selector
                Picker("Mode", selection: $selectedTab) {
                    Text("App Audio").tag(0)
                    Text("System Audio").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Content based on selected tab
                if selectedTab == 0 {
                    appAudioContent
                } else {
                    SystemAudioView()
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - App Audio Tab Content
    
    @ViewBuilder
    var appAudioContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status indicator
                HStack {
                    Circle()
                        .fill(audioManager.isRunning ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    
                    Text(audioManager.statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Start/Stop button
                Button(action: {
                    if audioManager.isRunning {
                        audioManager.stop()
                    } else {
                        audioManager.start()
                    }
                }) {
                    Text(audioManager.isRunning ? "Stop Processing" : "Start Processing")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(audioManager.isRunning ? Color.red : Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                // EQ Curve Graph (NEW - Phase 5)
                EQCurveView(audioManager: audioManager)
                
                // Presets Section (NEW - Phase 5)
                PresetsView(audioManager: audioManager)
                    .padding(.horizontal, 20)
                
                // Preset buttons (Quick access)
                HStack(spacing: 12) {
                    Button("Flat") {
                        audioManager.resetToFlat()
                    }
                    .buttonStyle(PresetButtonStyle(isActive: false))
                    
                    Button("Bass Boost") {
                        audioManager.applyBassBoost()
                    }
                    .buttonStyle(PresetButtonStyle(isActive: false))
                    
                    Button("Vocal") {
                        audioManager.applyVocalEnhance()
                    }
                    .buttonStyle(PresetButtonStyle(isActive: false))
                }
                .padding(.horizontal, 20)
                
                // EQ Bands Grid
                VStack(spacing: 16) {
                    // Split into 6x2 grid for better layout
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(0..<6, id: \.self) { col in
                                let bandIndex = row * 6 + col
                                if bandIndex < 12 {
                                    VStack(spacing: 0) {
                                        EQBandView(
                                            bandIndex: bandIndex,
                                            frequency: frequencies[bandIndex],
                                            gain: $audioManager.gains[bandIndex],
                                            action: { newValue in
                                                audioManager.setGain(band: bandIndex, value: newValue)
                                            }
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color(red: 0.15, green: 0.15, blue: 0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Advanced Settings (NEW - Phase 5)
                AdvancedSettingsView(audioManager: audioManager)
                
                // Footer info
                VStack(spacing: 4) {
                    Text("Gain Range: -12 dB to +12 dB")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Sample Rate: 44.1 kHz • Stereo Processing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

/**
 * PresetButtonStyle: Custom button styling for preset buttons
 */
struct PresetButtonStyle: ButtonStyle {
    let isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isActive ? Color.blue : Color(red: 0.2, green: 0.2, blue: 0.25))
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    ContentView()
}
