//
//  WhistleModels.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//

import Foundation

// MARK: - Whistle Key (строй вистла)

/// Строй вистла от высокого Eb до Low D (хроматически)
enum WhistleKey: String, CaseIterable {
    // От высокого к низкому
    case Eb = "Eb"
    case D_high = "D"
    case Csharp = "C#"
    case C = "C"
    case B = "B"
    case Bb = "Bb"
    case A = "A"
    case Ab = "Ab"
    case G = "G"
    case Fsharp = "F#"
    case F = "F"
    case E = "E"
    case Eb_low = "Low Eb"
    case D_low = "Low D"
    
    /// Название для отображения
    var displayName: String {
        switch self {
        case .Eb: return "E♭"
        case .D_high: return "D"
        case .Csharp: return "C#"
        case .C: return "C"
        case .B: return "B"
        case .Bb: return "B♭"
        case .A: return "A"
        case .Ab: return "A♭"
        case .G: return "G"
        case .Fsharp: return "F#"
        case .F: return "F"
        case .E: return "E"
        case .Eb_low: return "Low E♭"
        case .D_low: return "Low D"
        }
    }
    
    /// Номер ноты тоники (0-11, где C=0, D=2, и т.д.)
    var tonicNote: Int {
        switch self {
        case .Eb, .Eb_low:    return 3   // Eb
        case .D_high, .D_low: return 2   // D
        case .Csharp:         return 1   // C#
        case .C:              return 0   // C
        case .B:              return 11  // B
        case .Bb:             return 10  // Bb
        case .A:              return 9   // A
        case .Ab:             return 8   // Ab
        case .G:              return 7   // G
        case .Fsharp:         return 6   // F#
        case .F:              return 5   // F
        case .E:              return 4   // E
        }
    }
}

// MARK: - Whistle Scale Degree

enum WhistleScaleDegree: String, CaseIterable {
    case I = "I"
    case II = "II"
    case III = "III"
    case IV = "IV"
    case V = "V"
    case VI = "VI"
    case flatVII = "♭VII"
    case VII = "VII"
    case I2 = "I²"
    case II2 = "II²"
    case III2 = "III²"
    case IV2 = "IV²"
    case V2 = "V²"
    case VI2 = "VI²"
    case VII2 = "VII²"
    
    var imageName: String { rawValue }
}

// MARK: - Pitch to Degree Converter

struct WhistleConverter {
    
    /// Преобразует MIDI pitch в аппликатуру на выбранном вистле
    /// Возвращает nil если нота не может быть сыграна на данном вистле (хроматическая нота)
    static func pitchToFingering(_ pitch: UInt8, whistleKey: WhistleKey) -> WhistleScaleDegree? {
        let midiPitch = Int(pitch)
        let pitchNote = midiPitch % 12  // Нота без октавы (0-11)
        let whistleTonicNote = whistleKey.tonicNote
        
        // Вычисляем интервал от тоники вистла (0-11)
        var interval = pitchNote - whistleTonicNote
        if interval < 0 {
            interval += 12
        }
        
        // Определяем октаву: от C5 (72) и выше - верхняя октава
        let isUpperOctave = midiPitch >= 72
        
        // Только диатонические ступени мажорной гаммы
        switch interval {
        case 0:  return isUpperOctave ? .I2 : .I
        case 2:  return isUpperOctave ? .II2 : .II
        case 4:  return isUpperOctave ? .III2 : .III
        case 5:  return isUpperOctave ? .IV2 : .IV
        case 7:  return isUpperOctave ? .V2 : .V
        case 9:  return isUpperOctave ? .VI2 : .VI
        case 10: return .flatVII  // ♭VII только в первой октаве
        case 11: return isUpperOctave ? .VII2 : .VII
        default: return nil  // Хроматические ноты
        }
    }
    
    static func pitchToNoteName(_ pitch: UInt8) -> String {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let octave = Int(pitch) / 12 - 1
        let note = Int(pitch) % 12
        return "\(noteNames[note])\(octave)"
    }

    /// Находит все тональности, в которых мелодия может быть полностью сыграна на данном вистле
    /// - Parameters:
    ///   - notes: оригинальные ноты мелодии
    ///   - whistleKey: строй вистла
    ///   - baseKey: базовая тональность мелодии (для расчета результирующих тональностей)
    /// - Returns: массив уникальных тональностей мелодии, где все ноты playable на данном вистле
    static func findPlayableKeys(for notes: [MIDINote], whistleKey: WhistleKey, baseKey: String) -> [String] {
        var playableKeysSet = Set<String>()

        // Извлекаем базовую ноту из тональности
        let baseNoteIndex = noteNameToIndex(baseKey)

        // Проверяем каждое возможное транспонирование (-12 до +12 полутонов)
        for transpose in -12...12 {
            // Проверяем, playable ли все ноты при этом транспонировании
            let allPlayable = notes.allSatisfy { note in
                let transposedPitch = max(0, min(127, Int(note.pitch) + transpose))
                return pitchToFingering(UInt8(transposedPitch), whistleKey: whistleKey) != nil
            }

            if allPlayable {
                // Рассчитываем результирующую тональность мелодии
                let newNoteIndex = (baseNoteIndex + transpose + 12) % 12
                let newKey = indexToNoteName(newNoteIndex, isMinor: baseKey.lowercased().hasSuffix("m"))
                playableKeysSet.insert(newKey)
            }
        }

        // Возвращаем отсортированный массив уникальных тональностей
        return Array(playableKeysSet).sorted()
    }

    /// Преобразует название ноты в индекс (C=0, C#=1, D=2, ...)
    private static func noteNameToIndex(_ noteName: String) -> Int {
        let normalizedName = noteName.replacingOccurrences(of: "♭", with: "b")
        let noteMap: [String: Int] = [
            "C": 0, "C#": 1, "Db": 1, "C♯": 1, "D": 2, "D#": 3, "Eb": 3, "D♯": 3, "E": 4,
            "F": 5, "F#": 6, "Gb": 6, "F♯": 6, "G": 7, "G#": 8, "Ab": 8, "G♯": 8, "A": 9,
            "A#": 10, "Bb": 10, "A♯": 10, "B": 11
        ]

        // Извлекаем ноту из тональности (убираем суффиксы)
        var baseNote = normalizedName
        for suffix in ["m", "min", "maj", "dor", "phr", "lyd", "mix", "loc"] {
            if baseNote.lowercased().hasSuffix(suffix) {
                baseNote = String(baseNote.dropLast(suffix.count))
                break
            }
        }

        return noteMap[baseNote] ?? 0
    }

    /// Преобразует индекс в название ноты
    private static func indexToNoteName(_ index: Int, isMinor: Bool) -> String {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let noteName = noteNames[(index + 12) % 12]
        return isMinor ? "\(noteName)m" : noteName
    }
}

// MARK: - Key Converter

extension WhistleKey {
    /// Преобразует тональность мелодии (например "Dmaj", "Ador", "G") в строй вистла
    static func from(tuneKey: String) -> WhistleKey {
        let key = tuneKey.trimmingCharacters(in: .whitespaces).uppercased()
        
        guard !key.isEmpty else { return .D_high }
        
        let firstChar = key.prefix(1)
        var noteName = String(firstChar)
        
        if key.count >= 2 {
            let second = key[key.index(key.startIndex, offsetBy: 1)]
            if second == "#" {
                noteName += "#"
            } else if second == "B" && key.prefix(2) != "BB" {
                // Проверяем что это бемоль, а не начало "BB" или "BMAJ"
                if key.hasPrefix("BB") || key.hasPrefix("BM") {
                    noteName = "B"
                }
            }
        }
        
        switch noteName {
        case "EB", "E♭": return .Eb
        case "D": return .D_high
        case "C#", "DB", "D♭": return .Csharp
        case "C": return .C
        case "B": return .B
        case "BB", "B♭", "A#": return .Bb
        case "A": return .A
        case "AB", "A♭", "G#": return .Ab
        case "G": return .G
        case "F#", "GB", "G♭": return .Fsharp
        case "F": return .F
        case "E": return .E
        default: return .D_high
        }
    }
}

