//
//  FingeringImageView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//
import SwiftUI

struct FingeringImageView: View {
    let note: MIDINote
    let width: CGFloat
    let whistleKey: WhistleKey
    
    var body: some View {
        if let degree = WhistleConverter.pitchToFingering(note.pitch, whistleKey: whistleKey) {
            // Используем картинку соответствующей октавы (I, II, III... или I², II², III²...)
            Image(degree.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            // Неизвестная нота (хроматическая)
            VStack(spacing: 1) {
                Text("?")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                Text(WhistleConverter.pitchToNoteName(note.pitch))
                    .font(.system(size: 7))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    HStack {
        FingeringImageView(
            note: MIDINote(pitch: 62, velocity: 80, startBeat: 0, duration: 2, channel: 0),
            width: 60,
            whistleKey: .D_high
        )
        FingeringImageView(
            note: MIDINote(pitch: 74, velocity: 80, startBeat: 0, duration: 2, channel: 0),
            width: 60,
            whistleKey: .D_high
        )
    }
    .frame(height: 60)
    .padding()
    .background(Color.white)
}
