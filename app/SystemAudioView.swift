import SwiftUI

/**
 * SystemAudioView: System-wide audio routing and control
 */
struct SystemAudioView: View {
    @StateObject private var systemAudio = SystemAudioManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("System-Wide Audio")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(systemAudio.isSystemWideEnabled ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    
                    Text(systemAudio.statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            // Enable/Disable Toggle
            Toggle("Enable System-Wide EQ", isOn: Binding(
                get: { systemAudio.isSystemWideEnabled },
                set: { newValue in
                    if newValue {
                        systemAudio.enableSystemWide()
                    } else {
                        systemAudio.disableSystemWide()
                    }
                }
            ))
            .toggleStyle(.switch)
            .padding(.horizontal, 20)
            
            if systemAudio.isSystemWideEnabled {
                // Device selector
                VStack(spacing: 12) {
                    Text("Output Device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("Output Device", selection: $systemAudio.selectedOutputDevice) {
                        ForEach(systemAudio.audioDevices.filter { $0.isOutput }, id: \.self) { device in
                            Text(device.displayName).tag(device as SystemAudioManager.AudioDevice?)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .padding(12)
                .background(Color(red: 0.15, green: 0.15, blue: 0.2))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Bypass control
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bypass EQ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Toggle("", isOn: Binding(
                            get: { systemAudio.virtualDevice?.isBypass() ?? false },
                            set: { systemAudio.setBypass($0) }
                        ))
                        .toggleStyle(.switch)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Status")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(systemAudio.virtualDevice?.isRunning() ?? false ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(systemAudio.virtualDevice?.isRunning() ?? false ? .green : .gray)
                    }
                }
                .padding(12)
                .background(Color(red: 0.15, green: 0.15, blue: 0.2))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Warning
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("System-wide EQ will process audio from all applications. Disable for normal operation.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(Color(red: 0.3, green: 0.25, blue: 0.15))
                .cornerRadius(8)
                .padding(.horizontal, 20)
            }
            
            // Refresh button
            Button(action: {
                systemAudio.refreshAudioDevices()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh Audio Devices")
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    SystemAudioView()
        .preferredColorScheme(.dark)
        .background(Color(red: 0.05, green: 0.05, blue: 0.1))
}
