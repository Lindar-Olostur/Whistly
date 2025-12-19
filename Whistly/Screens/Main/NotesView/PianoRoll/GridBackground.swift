import SwiftUI

struct GridBackground: View {
    let rows: Int
    let beats: Int
    let noteHeight: CGFloat
    let beatWidth: CGFloat
    let beatsPerMeasure: Int
    let pitchRange: ClosedRange<UInt8>
    
    var body: some View {
        Canvas { context, size in
            for row in 0...rows {
                let y = CGFloat(row) * noteHeight
                let pitch = Int(pitchRange.upperBound) - row
                let isBlackKey = [1, 3, 6, 8, 10].contains(pitch % 12)
                
                if row < rows && isBlackKey {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: noteHeight)
                    context.fill(Path(rect), with: .color(Color.white.opacity(0.03)))
                }
                
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color.white.opacity(0.1)), lineWidth: 0.5)
            }
            
            for beat in 0...beats {
                let x = CGFloat(beat) * beatWidth
                let isMeasureStart = beat % beatsPerMeasure == 0
                
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                
                if isMeasureStart {
                    context.stroke(path, with: .color(Color.white.opacity(0.3)), lineWidth: 1)
                } else {
                    context.stroke(path, with: .color(Color.white.opacity(0.1)), lineWidth: 0.5)
                }
            }
        }
    }
}

#Preview {
    GridBackground(
        rows: 13,
        beats: 16,
        noteHeight: 8,
        beatWidth: 40,
        beatsPerMeasure: 4,
        pitchRange: 60...72
    )
    .frame(width: 640, height: 104)
    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
}
