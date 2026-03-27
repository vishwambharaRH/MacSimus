import Foundation

/**
 * EQPreset: Represents a saved EQ configuration
 */
struct EQPreset: Codable {
    let name: String
    let gains: [Float]
    let qFactors: [Float]
    let frequencies: [Float]
    let isBuiltIn: Bool
    let createdDate: Date
}

/**
 * PresetManager: Manages saving, loading, and deleting EQ presets
 * Uses UserDefaults for persistence
 */
class PresetManager: ObservableObject {
    static let shared = PresetManager()
    
    @Published var presets: [EQPreset] = []
    @Published var activePresetName: String = "None"
    
    private let presetKey = "MacSimus_Presets"
    private let activePresetKey = "MacSimus_ActivePreset"
    
    // Built-in presets
    private let builtInPresets: [EQPreset] = [
        EQPreset(
            name: "Flat",
            gains: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            qFactors: Array(repeating: 0.707, count: 12),
            frequencies: [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800],
            isBuiltIn: true,
            createdDate: Date()
        ),
        EQPreset(
            name: "Bass Boost",
            gains: [6, 4, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            qFactors: Array(repeating: 0.707, count: 12),
            frequencies: [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800],
            isBuiltIn: true,
            createdDate: Date()
        ),
        EQPreset(
            name: "Vocal Enhance",
            gains: [0, 0, 0, 3, 4, 3, 0, 0, 0, 0, 0, 0],
            qFactors: Array(repeating: 0.707, count: 12),
            frequencies: [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800],
            isBuiltIn: true,
            createdDate: Date()
        ),
        EQPreset(
            name: "Bright",
            gains: [-2, 0, 0, 0, 0, 2, 2, 3, 4, 3, 2, 2],
            qFactors: Array(repeating: 0.707, count: 12),
            frequencies: [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800],
            isBuiltIn: true,
            createdDate: Date()
        ),
        EQPreset(
            name: "Warm",
            gains: [3, 2, 1, 0, -1, -2, 0, 1, 0, -1, -2, -3],
            qFactors: Array(repeating: 0.707, count: 12),
            frequencies: [20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800],
            isBuiltIn: true,
            createdDate: Date()
        )
    ]
    
    init() {
        loadPresets()
    }
    
    private func loadPresets() {
        // Load custom presets
        if let data = UserDefaults.standard.data(forKey: presetKey) {
            if let decoded = try? JSONDecoder().decode([EQPreset].self, from: data) {
                presets = decoded
            }
        }
        
        // Add built-in presets if not already present
        for builtIn in builtInPresets {
            if !presets.contains(where: { $0.name == builtIn.name }) {
                presets.append(builtIn)
            }
        }
        
        // Load active preset name
        activePresetName = UserDefaults.standard.string(forKey: activePresetKey) ?? "None"
    }
    
    func savePreset(_ preset: EQPreset) {
        // Don't allow overwriting built-in presets
        if preset.isBuiltIn {
            return
        }
        
        // Remove existing preset with same name if not built-in
        presets.removeAll { $0.name == preset.name && !$0.isBuiltIn }
        presets.append(preset)
        
        persistPresets()
    }
    
    func createCustomPreset(name: String, gains: [Float], qFactors: [Float], frequencies: [Float]) {
        let preset = EQPreset(
            name: name,
            gains: gains,
            qFactors: qFactors,
            frequencies: frequencies,
            isBuiltIn: false,
            createdDate: Date()
        )
        
        savePreset(preset)
    }
    
    func deletePreset(_ preset: EQPreset) {
        // Don't allow deleting built-in presets
        if preset.isBuiltIn {
            return
        }
        
        presets.removeAll { $0.name == preset.name }
        
        if activePresetName == preset.name {
            activePresetName = "None"
            UserDefaults.standard.set("None", forKey: activePresetKey)
        }
        
        persistPresets()
    }
    
    func loadPreset(_ preset: EQPreset) {
        activePresetName = preset.name
        UserDefaults.standard.set(preset.name, forKey: activePresetKey)
    }
    
    func getPreset(named name: String) -> EQPreset? {
        return presets.first { $0.name == name }
    }
    
    private func persistPresets() {
        // Only save custom presets (not built-in)
        let customPresets = presets.filter { !$0.isBuiltIn }
        if let encoded = try? JSONEncoder().encode(customPresets) {
            UserDefaults.standard.set(encoded, forKey: presetKey)
        }
    }
}
