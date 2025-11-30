//
//  NoteView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//
import SwiftUI

struct NoteView: View {
    let note: MIDINote
    let pitchRange: ClosedRange<UInt8>
    let noteHeight: CGFloat
    let beatWidth: CGFloat
    let startBeatOffset: Double
    let isActive: Bool
    
    var body: some View {
        let row = Int(pitchRange.upperBound) - Int(note.pitch)
        let y = CGFloat(row) * noteHeight + 1
        let x = CGFloat(note.startBeat - startBeatOffset) * beatWidth
        let width = max(CGFloat(note.duration) * beatWidth - 2, 4)
        
        RoundedRectangle(cornerRadius: 2)
            .fill(noteColor)
            .frame(width: width, height: noteHeight - 2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(isActive ? 0.5 : 0.2), lineWidth: 0.5)
            )
            .shadow(color: noteColor.opacity(isActive ? 0.6 : 0), radius: 4)
            .offset(x: x, y: y)
            .animation(.easeInOut(duration: 0.1), value: isActive)
    }
    
    private var noteColor: Color {
        if isActive {
            return Color(red: 1.0, green: 0.6, blue: 0.2) // Оранжевый для активной
        }
        
        // Цвет по каналу или высоте
        let hue = Double(note.pitch % 12) / 12.0
        return Color(hue: hue * 0.3 + 0.55, saturation: 0.7, brightness: 0.8) // Фиолетово-голубая гамма
    }
}

#Preview {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.12)
        
        NoteView(
            note: MIDINote(pitch: 62, velocity: 80, startBeat: 0, duration: 2, channel: 0),
            pitchRange: 60...72,
            noteHeight: 8,
            beatWidth: 40,
            startBeatOffset: 0,
            isActive: false
        )
    }
    .frame(width: 200, height: 100)
}
