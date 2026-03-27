import SwiftUI

/**
 * AdvancedSettingsView: Advanced EQ controls for fine-tuning
 * Allows adjustment of Q-factor (bandwidth) and center frequency per band
 */
struct AdvancedSettingsView: View {
    @ObservedObject var audioManager: AudioManager
    @State private var isExpanded = false
    @State private var selectedBandIndex = 0
    
    let frequencies = [
        "20 Hz", "35 Hz", "61 Hz", "106 Hz",
        "185 Hz", "320 Hz", "560 Hz", "970 Hz",
        "1.7 kHz", "2.9 kHz", "5.1 kHz", "8.8 kHz"
    ]
    
    let frequencyValues = [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800]
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.blue)
                    
                    Text("Advanced Settings")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(red: 0.12, green: 0.12, blue: 0.17))
                .cornerRadius(8)
            }
            
            if isExpanded {
                VStack(spacing: 16) {
                    // Band selector
                    VStack(spacing: 8) {
                        Text("Select Band")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Picker("Band", selection: $selectedBandIndex) {
                            ForEach(0..<12, id: \.self) { index in
                                Text("\(frequencies[index])").tag(index)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Divider()
                        .background(Color(white: 0.2))
                    
                    // Q-Factor control
                    VStack(spacing: 8) {
                        HStack {
                            Text("Q Factor (Bandwidth)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.2f", audioManager.qFactors[selectedBandIndex]))
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        
                        Slider(
                            value: $audioManager.qFactors[selectedBandIndex],
                            in: 0.3...2.5,
                            step: 0.1
                        )
                        .onChange(of: audioManager.qFactors[selectedBandIndex]) { newValue in
                            audioManager.setQFactor(band: selectedBandIndex, value: newValue)
                        }
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .center) {
                                Text("Narrow")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 3)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("Wide")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 3)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color(white: 0.2))
                    
                    // Center Frequency fine-tuning
                    VStack(spacing: 8) {
                        HStack {
                            Text("Center Frequency")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(audioManager.frequencies[selectedBandIndex])) Hz")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        
                        Slider(
                            value: $audioManager.frequencies[selectedBandIndex],
                            in: CGFloat(frequencyValues[selectedBandIndex]) * 0.8 ...
                                CGFloat(frequencyValues[selectedBandIndex]) * 1.2,
                            step: 1
                        )
                        .onChange(of: audioManager.frequencies[selectedBandIndex]) { newValue in
                            audioManager.setFrequency(band: selectedBandIndex, value: newValue)
                        }
                    }
                    
                    Divider()
                        .background(Color(white: 0.2))
                    
                    // Master Gain control
                    VStack(spacing: 8) {
                        HStack {
                            Text("Master Volume")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%+.1f dB", audioManager.masterGain))
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                        
                        Slider(
                            value: $audioManager.masterGain,
                            in: -6...6,
                            step: 0.1
                        )
                        .onChange(of: audioManager.masterGain) { newValue in
                            audioManager.setMasterGain(value: newValue)
                        }
                    }
                    
                    // Reset button
                    Button(action: {
                        audioManager.resetBandToDefaults(selectedBandIndex)
                    }) {
                        Text("Reset Band to Defaults")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.3, green: 0.2, blue: 0.1))
                            .cornerRadius(6)
                    }
                }
                .padding(12)
                .background(Color(red: 0.1, green: 0.1, blue: 0.15))
                .cornerRadius(8)
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    @StateObject var audioManager = AudioManager()
    
    return AdvancedSettingsView(audioManager: audioManager)
        .padding()
        .background(Color(red: 0.05, green: 0.05, blue: 0.1))
}
