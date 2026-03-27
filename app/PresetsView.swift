import SwiftUI

/**
 * PresetsView: UI for managing and loading EQ presets
 */
struct PresetsView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var presetManager = PresetManager.shared
    @State private var showNewPresetSheet = false
    @State private var newPresetName = ""
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text("Presets")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showNewPresetSheet = true }) {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 12)
            
            // Active preset indicator
            if presetManager.activePresetName != "None" {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6)
                    
                    Text("Active: \(presetManager.activePresetName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
            }
            
            // Preset list
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(presetManager.presets, id: \.name) { preset in
                        PresetRowView(
                            preset: preset,
                            isActive: presetManager.activePresetName == preset.name,
                            onSelect: {
                                presetManager.loadPreset(preset)
                                audioManager.applyPreset(preset)
                            },
                            onDelete: {
                                presetManager.deletePreset(preset)
                            }
                        )
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 12)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(8)
        .sheet(isPresented: $showNewPresetSheet) {
            NewPresetSheet(
                isPresented: $showNewPresetSheet,
                audioManager: audioManager,
                presetManager: presetManager
            )
        }
    }
}

struct PresetRowView: View {
    let preset: EQPreset
    let isActive: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(preset.name)
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(isActive ? .bold : .regular)
                    
                    if preset.isBuiltIn {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                    
                    Spacer()
                }
                
                Text("Created: \(preset.createdDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: onSelect) {
                    Image(systemName: "checkmark.circle")
                        .font(.title3)
                        .foregroundColor(isActive ? .green : .gray)
                }
                
                if !preset.isBuiltIn {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(10)
        .background(isActive ? Color(red: 0.15, green: 0.25, blue: 0.35) : Color(red: 0.12, green: 0.12, blue: 0.17))
        .cornerRadius(6)
    }
}

struct NewPresetSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var presetManager: PresetManager
    @State private var presetName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Preset Name", text: $presetName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    
                    Button("Save") {
                        if !presetName.isEmpty {
                            presetManager.createCustomPreset(
                                name: presetName,
                                gains: audioManager.gains,
                                qFactors: audioManager.qFactors,
                                frequencies: audioManager.frequencies
                            )
                            presetManager.loadPreset(
                                presetManager.presets.first { $0.name == presetName }!
                            )
                            isPresented = false
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("New Preset")
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    @StateObject var audioManager = AudioManager()
    
    return PresetsView(audioManager: audioManager)
        .padding()
        .background(Color(red: 0.05, green: 0.05, blue: 0.1))
}
