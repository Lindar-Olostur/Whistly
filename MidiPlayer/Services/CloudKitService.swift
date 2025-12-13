////
////  CloudKitService.swift
////  MidiPlayer
////
////  Created by Lindar Olostur on 13.12.2025.
////
//
//import CloudKit
//import Foundation
//
//@MainActor
//class CloudKitService: ObservableObject {
//    static let shared = CloudKitService()
//    
//    private let container: CKContainer
//    private let privateDatabase: CKDatabase
//    
//    @Published var isSyncing = false
//    @Published var lastSyncDate: Date?
//    @Published var syncError: String?
//    @Published var isCloudAvailable = false
//    
//    private let tuneRecordType = "Tune"
//    
//    private init() {
//        container = CKContainer(identifier: "iCloud.com.lindarolostur.MidiPlayer")
//        privateDatabase = container.privateCloudDatabase
//        
//        Task {
//            await checkCloudStatus()
//        }
//    }
//    
//    func checkCloudStatus() async {
//        do {
//            let status = try await container.accountStatus()
//            isCloudAvailable = status == .available
//            if !isCloudAvailable {
//                syncError = "iCloud недоступен. Войдите в iCloud в настройках."
//            } else {
//                syncError = nil
//            }
//        } catch {
//            isCloudAvailable = false
//            syncError = "Ошибка проверки iCloud: \(error.localizedDescription)"
//        }
//    }
//    
//    func uploadTune(_ tune: TuneModel, fileData: Data) async throws {
//        guard isCloudAvailable else {
//            throw CloudKitError.cloudNotAvailable
//        }
//        
//        isSyncing = true
//        defer { isSyncing = false }
//        
//        let record = CKRecord(recordType: tuneRecordType, recordID: CKRecord.ID(recordName: tune.id.uuidString))
//        
//        record["fileName"] = tune.fileName
//        record["fileType"] = tune.fileType.rawValue
//        record["originalFileName"] = tune.originalFileName
//        record["dateAdded"] = tune.dateAdded
//        record["transpose"] = tune.transpose
//        record["tempo"] = tune.tempo
//        record["whistleKey"] = tune.whistleKey.rawValue
//        record["selectedKey"] = tune.selectedKey
//        record["startMeasure"] = tune.startMeasure
//        record["endMeasure"] = tune.endMeasure
//        record["selectedTuneIndex"] = tune.selectedTuneIndex
//        record["title"] = tune.title
//        record["detectedKey"] = tune.detectedKey
//        record["isEdited"] = tune.isEdited ? 1 : 0
//        
//        if let loopsData = try? JSONEncoder().encode(tune.measureLoops) {
//            record["measureLoops"] = loopsData
//        }
//        record["selectedLoopId"] = tune.selectedLoopId?.uuidString
//        
//        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(tune.fileName)
//        try fileData.write(to: tempURL)
//        let asset = CKAsset(fileURL: tempURL)
//        record["fileAsset"] = asset
//        
//        do {
//            try await privateDatabase.save(record)
//            try? FileManager.default.removeItem(at: tempURL)
//            lastSyncDate = Date()
//            syncError = nil
//        } catch {
//            try? FileManager.default.removeItem(at: tempURL)
//            throw error
//        }
//    }
//    
//    func fetchAllTunes() async throws -> [(TuneModel, Data)] {
//        guard isCloudAvailable else {
//            throw CloudKitError.cloudNotAvailable
//        }
//        
//        isSyncing = true
//        defer { isSyncing = false }
//        
//        let query = CKQuery(recordType: tuneRecordType, predicate: NSPredicate(value: true))
//        query.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
//        
//        let (results, _) = try await privateDatabase.records(matching: query)
//        
//        var tunes: [(TuneModel, Data)] = []
//        
//        for (_, result) in results {
//            switch result {
//            case .success(let record):
//                if let tune = try await parseTuneRecord(record) {
//                    tunes.append(tune)
//                }
//            case .failure:
//                continue
//            }
//        }
//        
//        lastSyncDate = Date()
//        syncError = nil
//        return tunes
//    }
//    
//    func deleteTune(_ tuneId: UUID) async throws {
//        guard isCloudAvailable else {
//            throw CloudKitError.cloudNotAvailable
//        }
//        
//        isSyncing = true
//        defer { isSyncing = false }
//        
//        let recordID = CKRecord.ID(recordName: tuneId.uuidString)
//        try await privateDatabase.deleteRecord(withID: recordID)
//    }
//    
//    private func parseTuneRecord(_ record: CKRecord) async throws -> (TuneModel, Data)? {
//        guard let fileName = record["fileName"] as? String,
//              let fileTypeRaw = record["fileType"] as? String,
//              let fileType = SourceType(rawValue: fileTypeRaw),
//              let originalFileName = record["originalFileName"] as? String,
//              let dateAdded = record["dateAdded"] as? Date,
//              let asset = record["fileAsset"] as? CKAsset,
//              let fileURL = asset.fileURL else {
//            return nil
//        }
//        
//        let fileData = try Data(contentsOf: fileURL)
//        
//        guard let idString = record.recordID.recordName as String?,
//              let id = UUID(uuidString: idString) else {
//            return nil
//        }
//        
//        let transpose = record["transpose"] as? Int ?? 0
//        let tempo = record["tempo"] as? Double ?? 120
//        let whistleKeyRaw = record["whistleKey"] as? String ?? WhistleKey.D_high.rawValue
//        let whistleKey = WhistleKey(rawValue: whistleKeyRaw) ?? .D_high
//        let selectedKey = record["selectedKey"] as? String
//        let startMeasure = record["startMeasure"] as? Int ?? 1
//        let endMeasure = record["endMeasure"] as? Int ?? 1
//        let selectedTuneIndex = record["selectedTuneIndex"] as? Int ?? 0
//        let title = record["title"] as? String
//        let detectedKey = record["detectedKey"] as? String
//        let isEdited = (record["isEdited"] as? Int ?? 0) == 1
//        
//        var measureLoops: [MeasureLoop] = []
//        if let loopsData = record["measureLoops"] as? Data {
//            measureLoops = (try? JSONDecoder().decode([MeasureLoop].self, from: loopsData)) ?? []
//        }
//        
//        var selectedLoopId: UUID?
//        if let loopIdString = record["selectedLoopId"] as? String {
//            selectedLoopId = UUID(uuidString: loopIdString)
//        }
//        
//        let tune = TuneModel(
//            id: id,
//            fileName: fileName,
//            fileType: fileType,
//            originalFileName: originalFileName,
//            dateAdded: dateAdded,
//            transpose: transpose,
//            tempo: tempo,
//            whistleKey: whistleKey,
//            selectedKey: selectedKey,
//            startMeasure: startMeasure,
//            endMeasure: endMeasure,
//            selectedTuneIndex: selectedTuneIndex,
//            measureLoops: measureLoops,
//            selectedLoopId: selectedLoopId,
//            title: title,
//            detectedKey: detectedKey,
//            isEdited: isEdited,
//            editedNotes: nil
//        )
//        
//        return (tune, fileData)
//    }
//    
//    enum CloudKitError: LocalizedError {
//        case cloudNotAvailable
//        case recordNotFound
//        case invalidData
//        
//        var errorDescription: String? {
//            switch self {
//            case .cloudNotAvailable:
//                return "iCloud недоступен"
//            case .recordNotFound:
//                return "Запись не найдена"
//            case .invalidData:
//                return "Неверные данные"
//            }
//        }
//    }
//}
//
