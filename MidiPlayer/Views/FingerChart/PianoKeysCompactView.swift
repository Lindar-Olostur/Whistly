//
//  PianoKeysCompactView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//
import SwiftUI

struct PianoKeysCompactView: View {
    let pitchRange: ClosedRange<UInt8>
    let noteHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((pitchRange).reversed(), id: \.self) { pitch in
                let isBlackKey = [1, 3, 6, 8, 10].contains(Int(pitch) % 12)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(isBlackKey ? Color(white: 0.18) : Color(white: 0.14))
                        .overlay(
                            Text(pitchToName(pitch))
                                .font(.system(size: 6, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 3)
                            , alignment: .trailing
                        )
                }
                .frame(height: noteHeight)
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 0.5)
                    , alignment: .bottom
                )
            }
        }
    }
    
    private func pitchToName(_ pitch: UInt8) -> String {
        _ = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let note = Int(pitch) % 12
        if note == 0 {
            let octave = Int(pitch) / 12 - 1
            return "C\(octave)"
        }
        return ""
    }
}

#Preview {
    PianoKeysCompactView(
        pitchRange: 60...72,
        noteHeight: 6
    )
    .frame(width: 35, height: 78)
    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
}
