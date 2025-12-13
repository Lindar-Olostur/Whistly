//
//  TuneModel.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 29.11.2025.
//

import Foundation

// MARK: - Measure Loop

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

// MARK: - Tune Model

/// Модель мелодии с настройками
struct TuneModel: Identifiable, Codable {
    let id: UUID
    let fileName: String
    let fileType: SourceType
    let originalFileName: String  // Имя файла при загрузке
    let dateAdded: Date
    
    // Настройки воспроизведения
    var transpose: Int = 0
    var tempo: Double = 120
    var whistleKey: WhistleKey = .D_high
    var selectedKey: String?  // Выбранная тональность из playable keys
    
    // Диапазон воспроизведения
    var startMeasure: Int = 1
    var endMeasure: Int = 1
    
    // Для ABC файлов
    var selectedTuneIndex: Int = 0
    
    // Лупы тактов
    var measureLoops: [MeasureLoop] = []
    var selectedLoopId: UUID?
    
    // Метаданные (из файла)
    var title: String?
    var detectedKey: String?
    
    // Флаг редактирования
    var isEdited: Bool = false
    var editedNotes: [MIDINote]?  // Для будущего редактирования
    
    // MARK: - Codable Support
    
    enum CodingKeys: String, CodingKey {
        case id, fileName, fileType, originalFileName, dateAdded
        case transpose, tempo, whistleKey, selectedKey
        case startMeasure, endMeasure, selectedTuneIndex
        case measureLoops, selectedLoopId
        case title, detectedKey, isEdited
    }
    
    init(id: UUID = UUID(),
         fileName: String,
         fileType: SourceType,
         originalFileName: String,
         dateAdded: Date = Date(),
         transpose: Int = 0,
         tempo: Double = 120,
         whistleKey: WhistleKey = .D_high,
         selectedKey: String? = nil,
         startMeasure: Int = 1,
         endMeasure: Int = 1,
         selectedTuneIndex: Int = 0,
         measureLoops: [MeasureLoop] = [],
         selectedLoopId: UUID? = nil,
         title: String? = nil,
         detectedKey: String? = nil,
         isEdited: Bool = false,
         editedNotes: [MIDINote]? = nil) {
        self.id = id
        self.fileName = fileName
        self.fileType = fileType
        self.originalFileName = originalFileName
        self.dateAdded = dateAdded
        self.transpose = transpose
        self.tempo = tempo
        self.whistleKey = whistleKey
        self.selectedKey = selectedKey
        self.startMeasure = startMeasure
        self.endMeasure = endMeasure
        self.selectedTuneIndex = selectedTuneIndex
        self.measureLoops = measureLoops
        self.selectedLoopId = selectedLoopId
        self.title = title
        self.detectedKey = detectedKey
        self.isEdited = isEdited
        self.editedNotes = editedNotes
    }
}

// MARK: - MIDINote Codable Extension

extension MIDINote: Codable {
    enum CodingKeys: String, CodingKey {
        case pitch, velocity, startBeat, duration, channel
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pitch = try container.decode(UInt8.self, forKey: .pitch)
        velocity = try container.decode(UInt8.self, forKey: .velocity)
        startBeat = try container.decode(Double.self, forKey: .startBeat)
        duration = try container.decode(Double.self, forKey: .duration)
        channel = try container.decode(UInt8.self, forKey: .channel)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pitch, forKey: .pitch)
        try container.encode(velocity, forKey: .velocity)
        try container.encode(startBeat, forKey: .startBeat)
        try container.encode(duration, forKey: .duration)
        try container.encode(channel, forKey: .channel)
    }
}

