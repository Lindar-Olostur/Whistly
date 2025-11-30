//
//  NoteViewCompact.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//
import SwiftUI


struct NoteViewCompact: View {
    let note: MIDINote
    let pitchRange: ClosedRange<UInt8>
    let noteHeight: CGFloat
    let beatWidth: CGFloat
    let startBeatOffset: Double
    let isActive: Bool
    
    var body: some View {
        let row = Int(pitchRange.upperBound) - Int(note.pitch)
        let y = CGFloat(row) * noteHeight + 0.5
        let x = CGFloat(note.startBeat - startBeatOffset) * beatWidth
        let width = max(CGFloat(note.duration) * beatWidth - 1, 3)
        
        RoundedRectangle(cornerRadius: 1.5)
            .fill(noteColor)
            .frame(width: width, height: noteHeight - 1)
            .overlay(
                RoundedRectangle(cornerRadius: 1.5)
                    .stroke(Color.white.opacity(isActive ? 0.4 : 0.15), lineWidth: 0.5)
            )
            .shadow(color: noteColor.opacity(isActive ? 0.6 : 0), radius: 3)
            .offset(x: x, y: y)
            .animation(.easeInOut(duration: 0.1), value: isActive)
    }
    
    private var noteColor: Color {
        if isActive {
            return Color.orange
        }
        let hue = Double(note.pitch % 12) / 12.0
        return Color(hue: hue * 0.3 + 0.55, saturation: 0.7, brightness: 0.75)
    }
}

#Preview {
    ZStack {
        Color(red: 0.1, green: 0.1, blue: 0.12)
        
        NoteViewCompact(
            note: MIDINote(pitch: 62, velocity: 80, startBeat: 0, duration: 2, channel: 0),
            pitchRange: 60...72,
            noteHeight: 6,
            beatWidth: 30,
            startBeatOffset: 0,
            isActive: false
        )
    }
    .frame(width: 100, height: 78)
}
