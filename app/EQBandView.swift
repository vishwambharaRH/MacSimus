import SwiftUI

/**
 * EQBandView: Individual EQ band slider component
 */
struct EQBandView: View {
    let bandIndex: Int
    let frequency: String
    @Binding var gain: Float
    let action: (Float) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Frequency label
            Text(frequency)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Slider
            VStack(spacing: 4) {
                Slider(value: $gain, in: -12...12, step: 0.5)
                    .onChange(of: gain) { newValue in
                        action(newValue)
                    }
                
                // Gain value display
                HStack {
                    if gain > 0 {
                        Text("+")
                    }
                    Text(String(format: "%.1f dB", gain))
                }
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(height: 16)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    @State var testGain: Float = 0
    
    return EQBandView(
        bandIndex: 0,
        frequency: "20 Hz",
        gain: $testGain,
        action: { _ in }
    )
    .padding()
}
