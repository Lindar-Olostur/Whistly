//import SwiftUI
//import Testing
//
//struct ModelTest: View {
//    let tune = testTune
//    let whistle: WhistleKey = .D
//    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .onAppear {
//                _ = TestKeyFinder().rangeFinder(for: whistle, tunes: TestKeyFinder().keyFinder(for: whistle, tune: testTune))
//            }
//    }
////    func whislteKeyTest() {
////        let converter = WhistleConverter()
////        
////        let uniqueNotes = Set(tune.map { $0.getNoteName() })
////        print("Уникальные ноты в мелодии: \(uniqueNotes.sorted().joined(separator: ", "))")
////        print("Всего уникальных нот: \(uniqueNotes.count)\n")
////        
////        var validKeys: [WhistleKey] = []
////        
////        for key in WhistleKey.allCases {
////            var noteStats: [String: [WhistleScaleDegree: Int]] = [:]
////            var playableNotes = Set<String>()
////            
////            for note in tune {
////                let noteName = note.getNoteName()
////                if let result = converter.pitchToFingering(UInt8(note), whistleKey: key) {
////                    playableNotes.insert(noteName)
////                    if noteStats[noteName] == nil {
////                        noteStats[noteName] = [:]
////                    }
////                    noteStats[noteName]![result] = (noteStats[noteName]![result] ?? 0) + 1
////                }
////            }
////            
////            let allNotesPlayable = uniqueNotes.isSubset(of: playableNotes)
////            
////            if allNotesPlayable {
////                validKeys.append(key)
////                print("\nТональность \(key.displayName) ✓")
////                
////                let sortedNotes = noteStats.keys.sorted()
////                for noteName in sortedNotes {
////                    guard let degrees = noteStats[noteName] else { continue }
////                    let totalCount = degrees.values.reduce(0, +)
////                    let degreesString = degrees
////                        .sorted { $0.key.rawValue < $1.key.rawValue }
////                        .map { "\($0.key.rawValue): \($0.value)" }
////                        .joined(separator: ", ")
////                    print("  \(noteName): \(totalCount) - \(degreesString)")
////                }
////            }
////        }
////        
////        print("\n\nИтого подходящих тональностей: \(validKeys.count)")
////        print("Тональности: \(validKeys.map { $0.displayName }.joined(separator: ", "))")
////    }
//}
//
//#Preview {
//    ModelTest()
//}
//    
//
//
//class TestKeyFinder {
//
//    func keyFinder(for whistle: WhistleKey, tune: [MIDINote]) -> [(Int, [MIDINote])] {
//        var result: [(Int, [MIDINote])] = []
//        print("Поиск возможных тональностей")
//        let whistleUniqueNotes = Set(whistle.getNotes().map { Int($0).getNoteName().dropLast() }).sorted()
//                print("Звукоряд Вистла \(whistle): \(whistleUniqueNotes)")
//        for i in 0...11 {
//            let tuneUniqueNotes = Set(tune.map { (Int($0.pitch) + i).getNoteName().dropLast() }).sorted()
//            var tuneNotesArray = tuneUniqueNotes
//            var scale: [String] = []
//            while !tuneNotesArray.isEmpty {
//                if let note = tuneNotesArray.popLast() {
//                    if !whistleUniqueNotes.contains(where: { $0 == note }) {
//                         break
//                    } else {
//                        scale.append(String(note))
//                    }
//                }
//            }
//            if scale.count == tuneUniqueNotes.count {
//                let transposedNotes = tune.map { note in
//                    MIDINote(
//                        pitch: UInt8(Int(note.pitch) + i),
//                        velocity: note.velocity,
//                        startBeat: note.startBeat,
//                        duration: note.duration,
//                        channel: note.channel
//                    )
//                }
//                result.append((i, transposedNotes))
//                print("Звукоряд мелодии +\(i) подошел: \(scale)")
//            }
//        }
////        let keys = result.map { KeyDetector.detectKey(from: $0) }
//        return result
//    }
//    
//    func rangeFinder(for whistle: WhistleKey, tunes: [(Int, [MIDINote])]) -> [PlayableKey] {
//        var result: [PlayableKey] = []
//        for tune in tunes {
//            guard let min = tune.1.map({ $0.pitch }).min(by: { $0 < $1 }) else { break }
//            guard let max = tune.1.map({ $0.pitch }).max(by: { $0 < $1 }) else { break }
//            if min - 12 >= whistle.pitchRange.min && max - 12 <= whistle.pitchRange.max {
//                if let root = tune.1.first?.pitch {
//                    result.append(PlayableKey(keyName: KeyDetector.detectKey(from: tune.1), transpose: tune.0, rootNote: root - 12))
//                }
//            } else if min >= whistle.pitchRange.min && max <= whistle.pitchRange.max {
//                if let root = tune.1.first?.pitch {
//                    result.append(PlayableKey(keyName: KeyDetector.detectKey(from: tune.1), transpose: tune.0, rootNote: root))
//                }
//            } else if min + 12 >= whistle.pitchRange.min && max + 12 <= whistle.pitchRange.max {
//                if let root = tune.1.first?.pitch {
//                    result.append(PlayableKey(keyName: KeyDetector.detectKey(from: tune.1), transpose: tune.0, rootNote: root + 12))
//                }
//            }
//        }
//        
//        print("Варианты тональностей мелодии для вистла \(whistle) - \(result.map { $0.keyName })")
//        return result
//    }
//}
//
//let testTune = [MIDINote(pitch: 74, velocity: 80, startBeat: 0.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 0.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 1.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 1.5, duration: 0.5, channel: 0), MIDINote(pitch: 74, velocity: 80, startBeat: 2.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 2.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 3.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 3.5, duration: 0.5, channel: 0), MIDINote(pitch: 74, velocity: 80, startBeat: 4.0, duration: 0.5, channel: 0), MIDINote(pitch: 76, velocity: 80, startBeat: 4.5, duration: 0.5, channel: 0), MIDINote(pitch: 74, velocity: 80, startBeat: 5.0, duration: 0.5, channel: 0), MIDINote(pitch: 72, velocity: 80, startBeat: 5.5, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 6.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 6.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 7.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 7.5, duration: 0.5, channel: 0), MIDINote(pitch: 62, velocity: 80, startBeat: 8.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 8.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 9.0, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 9.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 10.0, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 10.5, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 11.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 11.5, duration: 0.5, channel: 0), MIDINote(pitch: 72, velocity: 80, startBeat: 12.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 12.5, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 13.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 13.5, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 14.0, duration: 0.5, channel: 0), MIDINote(pitch: 62, velocity: 80, startBeat: 14.5, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 15.0, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 15.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 16.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 16.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 17.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 17.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 18.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 18.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 19.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 19.5, duration: 0.5, channel: 0), MIDINote(pitch: 74, velocity: 80, startBeat: 20.0, duration: 0.5, channel: 0), MIDINote(pitch: 72, velocity: 80, startBeat: 20.5, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 21.0, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 21.5, duration: 0.5, channel: 0), MIDINote(pitch: 72, velocity: 80, startBeat: 22.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 22.5, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 23.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 23.5, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 24.0, duration: 0.5, channel: 0), MIDINote(pitch: 62, velocity: 80, startBeat: 24.5, duration: 0.5, channel: 0), MIDINote(pitch: 66, velocity: 80, startBeat: 25.0, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 25.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 26.0, duration: 0.5, channel: 0), MIDINote(pitch: 64, velocity: 80, startBeat: 26.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 27.0, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 27.5, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 28.0, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 28.5, duration: 0.5, channel: 0), MIDINote(pitch: 72, velocity: 80, startBeat: 29.0, duration: 0.5, channel: 0), MIDINote(pitch: 71, velocity: 80, startBeat: 29.5, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 30.0, duration: 0.5, channel: 0), MIDINote(pitch: 62, velocity: 80, startBeat: 30.5, duration: 0.5, channel: 0), MIDINote(pitch: 67, velocity: 80, startBeat: 31.0, duration: 0.5, channel: 0), MIDINote(pitch: 69, velocity: 80, startBeat: 31.5, duration: 0.5, channel: 0)]
