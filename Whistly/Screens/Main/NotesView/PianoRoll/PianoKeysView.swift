import SwiftUI

struct PianoKeysView: View {
    let pitchRange: ClosedRange<UInt8>
    let noteHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((pitchRange).reversed(), id: \.self) { pitch in
                let isWhiteKey = [1, 3, 6, 8, 10].contains(Int(pitch) % 12)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(isWhiteKey ? .fillQuartenary : .clear)
//                        .background(.bgPrimary)
                        .overlay(
                            Text(pitchToName(pitch))
                                .font(.system(size: 7, weight: .medium, design: .monospaced))
                                .foregroundColor(.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 4)
                            , alignment: .trailing
                        )
                }
                .frame(height: noteHeight)
                .overlay(
                    Rectangle()
                        .fill(.textTertiary)
                        .frame(height: 0.5)
                    , alignment: .bottom
                )
            }
        }
    }
    
    private func pitchToName(_ pitch: UInt8) -> String {
        let octave = Int(pitch) / 12 - 1
        let note = Int(pitch) % 12
        if note == 0 {
            return "C\(octave)"
        }
        return ""
    }
}

#Preview {
    PianoKeysView(pitchRange: 60...72, noteHeight: 8)
        .frame(width: 50, height: 104)
        .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        .scaleEffect(4)
}
