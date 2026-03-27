import SwiftUI

/**
 * EQCurveView: Displays the frequency response curve of the EQ settings
 * Shows combined effect of all 12 bands with real-time updates
 */
struct EQCurveView: View {
    @ObservedObject var audioManager: AudioManager
    
    let frequencies = [
        20, 35, 61, 106, 185, 320, 560, 970, 1700, 2900, 5100, 8800
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("EQ Response Curve")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
            
            Canvas { context in
                let width: CGFloat = 280
                let height: CGFloat = 120
                let padding: CGFloat = 30
                
                // Draw grid background
                for i in 0...6 {
                    let y = padding + (height / 6) * CGFloat(i)
                    let path = Path(roundedRect: CGRect(x: padding, y: y, width: width, height: 0.5), cornerRadius: 0)
                    context.stroke(
                        path,
                        with: .color(Color(white: 0.15))
                    )
                }
                
                // Draw frequency response curve
                var curvePath = Path()
                var points: [(x: CGFloat, y: CGFloat)] = []
                
                for i in 0..<12 {
                    let gain = audioManager.gains[i]
                    let freq = frequencies[i]
                    
                    // Map frequency to x position (log scale)
                    let logFreq = log2(CGFloat(freq) / 20)
                    let maxLogFreq = log2(20000.0 / 20)
                    let x = padding + (logFreq / maxLogFreq) * width
                    
                    // Map gain to y position (-12 to +12 dB)
                    let centerY = padding + height / 2
                    let y = centerY - (CGFloat(gain) / 12) * (height / 2)
                    
                    points.append((x, y))
                }
                
                // Interpolate curve through points
                if !points.isEmpty {
                    curvePath.move(to: CGPoint(x: points[0].x, y: points[0].y))
                    
                    for i in 1..<points.count {
                        let p1 = points[i - 1]
                        let p2 = points[i]
                        let control = CGPoint(
                            x: (p1.x + p2.x) / 2,
                            y: (p1.y + p2.y) / 2
                        )
                        curvePath.addQuadCurve(
                            to: CGPoint(x: p2.x, y: p2.y),
                            control: control
                        )
                    }
                    
                    context.stroke(
                        curvePath,
                        with: .color(Color(red: 0.3, green: 0.7, blue: 1.0)),
                        lineWidth: 2.5
                    )
                }
                
                // Draw points on curve
                for point in points {
                    let rect = CGRect(x: point.x - 3, y: point.y - 3, width: 6, height: 6)
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color(red: 0.5, green: 0.8, blue: 1.0))
                    )
                }
                
                // Draw center line (0 dB reference)
                let centerY = padding + height / 2
                let centerPath = Path(roundedRect: CGRect(x: padding, y: centerY, width: width, height: 1), cornerRadius: 0)
                context.stroke(
                    centerPath,
                    with: .color(Color(white: 0.3)),
                    lineWidth: 1
                )
                
                // Draw frequency labels
                for i in [0, 5, 11] {
                    let logFreq = log2(CGFloat(frequencies[i]) / 20)
                    let maxLogFreq = log2(20000.0 / 20)
                    let x = padding + (logFreq / maxLogFreq) * width
                    
                    var textContext = context
                    let freq = frequencies[i]
                    let label = freq >= 1000 ? "\(freq / 1000)k Hz" : "\(freq) Hz"
                    
                    textContext.draw(
                        Text(label)
                            .font(.caption2)
                            .foregroundColor(.secondary),
                        at: CGPoint(x: x, y: padding + height + 10),
                        anchor: .topLeading
                    )
                }
                
                // Draw dB labels
                for i in [0, 1, 2] {
                    let db = (2 - i) * 6
                    let y = padding + (height / 2) - CGFloat(db) * (height / 24)
                    
                    var textContext = context
                    textContext.draw(
                        Text("\(db > 0 ? "+" : "")\(db)dB")
                            .font(.caption2)
                            .foregroundColor(.secondary),
                        at: CGPoint(x: 5, y: y),
                        anchor: .centerLeft
                    )
                }
            }
            .frame(height: 160)
            .background(Color(red: 0.08, green: 0.08, blue: 0.12))
            .cornerRadius(8)
            .padding(.horizontal, 12)
            
            // Frequency scale indicator
            HStack(spacing: 0) {
                Text("20 Hz")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("1 kHz")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("20 kHz")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 42)
        }
        .padding(.vertical, 12)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(8)
    }
}

#Preview {
    @StateObject var audioManager = AudioManager()
    
    return EQCurveView(audioManager: audioManager)
        .padding()
        .background(Color(red: 0.05, green: 0.05, blue: 0.1))
}
