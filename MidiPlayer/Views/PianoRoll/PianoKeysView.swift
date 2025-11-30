//
//  PianoKeysView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//
import SwiftUI

struct PianoKeysView: View {
    let pitchRange: ClosedRange<UInt8>
    let noteHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach((pitchRange).reversed(), id: \.self) { pitch in
                let isBlackKey = [1, 3, 6, 8, 10].contains(Int(pitch) % 12)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(isBlackKey ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color(red: 0.15, green: 0.15, blue: 0.18))
                        .overlay(
                            Text(pitchToName(pitch))
                                .font(.system(size: 7, weight: .medium, design: .monospaced))
                                .foregroundColor(.gray.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 4)
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
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = Int(pitch) / 12 - 1
        let note = Int(pitch) % 12
        // Показываем только ноты C для экономии места
        if note == 0 {
            return "C\(octave)"
        }
        return ""
    }
}

#Preview {
    PianoKeysView(
        pitchRange: 60...72,
        noteHeight: 8
    )
    .frame(width: 50, height: 104)
    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
}
