import SwiftUI

struct TuneModel: Identifiable, Codable {
    let id: String
    var abcContent: String
    let dateAdded: Date
    
    var transpose: Int = 0
    var tempo: Double = 120
    var whistleKey: WhistleKey = .D
    var selectedKey: String?
    
    var startMeasure: Int = 1
    var endMeasure: Int = 1
    
    var selectedTuneIndex: Int = 0
    
    var measureLoops: [MeasureLoop] = []
    var selectedLoopId: UUID?
    
    var title: String?
    var detectedKey: String?
    
    var tuneType: TuneType = .unknown
}

enum TuneType: String, CaseIterable, Codable {
    case unknown = "tune"
    case reel = "reel"
    case jig = "jig"
    case slip = "slip jig"
    case hornpipe = "hornpipe"
    case polka = "polka"
    case slide = "slide"
    case walz = "walz"
    case barndance = "barndance"
    case strathspey = "strathspey"
    case threeTwo = "three-two"
    case mazurka = "mazurka"
    case march = "march"
    
}
enum WhistleKey: String, CaseIterable, Codable {
    case Eb = "Eb"
    case D = "D"
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
    
    var displayName: String {
        switch self {
        case .Eb: return "E♭"
        case .D: return "D"
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
        }
    }
    
    var tonicNote: Int {
        switch self {
        case .Eb:      return 3
        case .D:       return 2
        case .Csharp:  return 1
        case .C:       return 0
        case .B:       return 11
        case .Bb:      return 10
        case .A:       return 9
        case .Ab:      return 8
        case .G:       return 7
        case .Fsharp:  return 6
        case .F:       return 5
        case .E:       return 4
        }
    }

    var pitchRange: (min: UInt8, max: UInt8) {
        switch self {
        case .D:       return (62, 83)  // D4 - B5
        case .Csharp:  return (61, 82)  // C#4 - A#5
        case .C:       return (60, 81)  // C4 - A5
        case .B:       return (59, 80)  // B3 - G#5
        case .Bb:      return (58, 79)  // A#3 - G5
        case .A:       return (57, 78)  // A3 - F#5
        case .Ab:      return (56, 77)  // G#3 - F5
        case .G:       return (55, 76)  // G3 - E5
        case .Fsharp:  return (66, 87)  // F#4 - D#6
        case .F:       return (65, 86)  // F4 - D6
        case .E:       return (64, 85)  // E4 - C#6
        case .Eb:      return (63, 84)  // Eb4 - C6
        }
    }
}

enum LoopType: String, Codable {
    case segment
    case half
    case full
}

struct MeasureLoop: Identifiable, Codable, Equatable {
    let id: UUID
    var startMeasure: Int
    var endMeasure: Int
    var isDefault: Bool
    var loopType: LoopType
    
    init(id: UUID = UUID(), startMeasure: Int, endMeasure: Int, isDefault: Bool = false, loopType: LoopType = .segment) {
        self.id = id
        self.startMeasure = startMeasure
        self.endMeasure = endMeasure
        self.isDefault = isDefault
        self.loopType = loopType
    }
    
    var title: String {
        if startMeasure == 1 && endMeasure == Int.max {
            return "All"
        }
        return "\(startMeasure)-\(endMeasure)"
    }
    
    static func generateDefaultLoops(totalMeasures: Int, beatsPerMeasure: Int) -> [MeasureLoop] {
        var segmentLoops: [MeasureLoop] = []
        var halfLoops: [MeasureLoop] = []
        var fullLoop: MeasureLoop?
        
        let loopLength: Int
        if totalMeasures <= 4 {
            loopLength = 2
        } else if totalMeasures <= 8 {
            loopLength = 2
        } else {
            switch beatsPerMeasure {
            case 6, 3:
                loopLength = 4
            case 2:
                loopLength = 8
            default:
                loopLength = 4
            }
        }
        
        var start = 1
        while start <= totalMeasures {
            let end = min(start + loopLength - 1, totalMeasures)
            if end > start || (start == 1 && end == 1) {
                if !(start == 1 && end == totalMeasures) {
                    segmentLoops.append(MeasureLoop(startMeasure: start, endMeasure: end, isDefault: true, loopType: .segment))
                }
            }
            start += loopLength
        }
        
        if totalMeasures > 1 {
            let halfPoint = totalMeasures / 2
            let firstHalfStart = 1
            let firstHalfEnd = halfPoint
            let secondHalfStart = halfPoint + 1
            let secondHalfEnd = totalMeasures
            
            var firstHalfExists = false
            var secondHalfExists = false
            
            for segment in segmentLoops {
                if segment.startMeasure == firstHalfStart && segment.endMeasure == firstHalfEnd {
                    firstHalfExists = true
                }
                if segment.startMeasure == secondHalfStart && segment.endMeasure == secondHalfEnd {
                    secondHalfExists = true
                }
            }
            
            if !firstHalfExists && firstHalfEnd >= 1 {
                halfLoops.append(MeasureLoop(startMeasure: firstHalfStart, endMeasure: firstHalfEnd, isDefault: true, loopType: .half))
            }
            if !secondHalfExists && secondHalfStart <= totalMeasures {
                halfLoops.append(MeasureLoop(startMeasure: secondHalfStart, endMeasure: secondHalfEnd, isDefault: true, loopType: .half))
            }
        }
        
        fullLoop = MeasureLoop(startMeasure: 1, endMeasure: totalMeasures, isDefault: true, loopType: .full)
        
        var result: [MeasureLoop] = []
        result.append(contentsOf: segmentLoops)
        result.append(contentsOf: halfLoops)
        if let full = fullLoop {
            result.append(full)
        }
        
        return result
    }
}
