
import Foundation

extension Int {
    func getNoteName() -> String {
        let noteNames = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
        guard self >= 0 && self <= 127 else {
            return "Invalid MIDI note"
        }
        let note = self % 12
        let octave = self / 12 - 1
        return "\(noteNames[note])\(octave)"
    }
    
    static func fromNoteName(_ noteName: String) -> Int? {
        let normalizedName = noteName.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "♭", with: "b")
            .replacingOccurrences(of: "♯", with: "#")
        
        let noteMap: [String: Int] = [
            "C": 0, "C#": 1, "Db": 1, "D": 2, "D#": 3, "Eb": 3, "E": 4,
            "F": 5, "F#": 6, "Gb": 6, "G": 7, "G#": 8, "Ab": 8, "A": 9,
            "A#": 10, "Bb": 10, "B": 11
        ]
        
        var notePart = ""
        var octavePart = ""
        var i = normalizedName.startIndex
        
        while i < normalizedName.endIndex {
            let char = normalizedName[i]
            if char.isNumber || char == "-" {
                octavePart = String(normalizedName[i...])
                break
            } else {
                notePart.append(char)
                i = normalizedName.index(after: i)
            }
        }
        
        guard let noteIndex = noteMap[notePart], !octavePart.isEmpty,
              let octave = Int(octavePart) else {
            return nil
        }
        
        let midiNote = (octave + 1) * 12 + noteIndex
        
        guard midiNote >= 0 && midiNote <= 127 else {
            return nil
        }
        
        return midiNote
    }
}
