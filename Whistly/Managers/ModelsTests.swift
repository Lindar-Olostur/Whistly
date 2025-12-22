import XCTest

final class WhistleConverterTests: XCTestCase {
    var converter: WhistleConverter!
    
    override func setUp() {
        super.setUp()
        converter = WhistleConverter()
    }
    
    override func tearDown() {
        converter = nil
        super.tearDown()
    }
    
    func testPitchToFingering_DWhistle_FirstOctave() {
        let whistleKey = WhistleKey.D
        
        XCTAssertEqual(converter.pitchToFingering(62, whistleKey: whistleKey), .I)
        XCTAssertEqual(converter.pitchToFingering(64, whistleKey: whistleKey), .II)
        XCTAssertEqual(converter.pitchToFingering(66, whistleKey: whistleKey), .III)
        XCTAssertEqual(converter.pitchToFingering(67, whistleKey: whistleKey), .IV)
        XCTAssertEqual(converter.pitchToFingering(69, whistleKey: whistleKey), .V)
        XCTAssertEqual(converter.pitchToFingering(71, whistleKey: whistleKey), .VI)
        XCTAssertEqual(converter.pitchToFingering(72, whistleKey: whistleKey), .flatVII)
        XCTAssertEqual(converter.pitchToFingering(73, whistleKey: whistleKey), .VII)
    }
    
    func testPitchToFingering_DWhistle_SecondOctave() {
        let whistleKey = WhistleKey.D
        
        XCTAssertEqual(converter.pitchToFingering(74, whistleKey: whistleKey), .I2)
        XCTAssertEqual(converter.pitchToFingering(76, whistleKey: whistleKey), .II2)
        XCTAssertEqual(converter.pitchToFingering(78, whistleKey: whistleKey), .III2)
        XCTAssertEqual(converter.pitchToFingering(79, whistleKey: whistleKey), .IV2)
        XCTAssertEqual(converter.pitchToFingering(81, whistleKey: whistleKey), .V2)
        XCTAssertEqual(converter.pitchToFingering(83, whistleKey: whistleKey), .VI2)
    }
    
    func testPitchToFingering_DWhistle_ChromaticNotes() {
        let whistleKey = WhistleKey.D
        
        XCTAssertNil(converter.pitchToFingering(63, whistleKey: whistleKey))
        XCTAssertNil(converter.pitchToFingering(65, whistleKey: whistleKey))
        XCTAssertNil(converter.pitchToFingering(68, whistleKey: whistleKey))
        XCTAssertNil(converter.pitchToFingering(70, whistleKey: whistleKey))
    }
    
    func testPitchToFingering_CWhistle_FirstOctave() {
        let whistleKey = WhistleKey.C
        
        XCTAssertEqual(converter.pitchToFingering(60, whistleKey: whistleKey), .I)
        XCTAssertEqual(converter.pitchToFingering(62, whistleKey: whistleKey), .II)
        XCTAssertEqual(converter.pitchToFingering(64, whistleKey: whistleKey), .III)
        XCTAssertEqual(converter.pitchToFingering(65, whistleKey: whistleKey), .IV)
        XCTAssertEqual(converter.pitchToFingering(67, whistleKey: whistleKey), .V)
        XCTAssertEqual(converter.pitchToFingering(69, whistleKey: whistleKey), .VI)
        XCTAssertEqual(converter.pitchToFingering(70, whistleKey: whistleKey), .flatVII)
        XCTAssertEqual(converter.pitchToFingering(71, whistleKey: whistleKey), .VII)
    }
    
    func testPitchToFingering_CWhistle_SecondOctave() {
        let whistleKey = WhistleKey.C
        
        XCTAssertEqual(converter.pitchToFingering(72, whistleKey: whistleKey), .I2)
        XCTAssertEqual(converter.pitchToFingering(74, whistleKey: whistleKey), .II2)
        XCTAssertEqual(converter.pitchToFingering(76, whistleKey: whistleKey), .III2)
        XCTAssertEqual(converter.pitchToFingering(77, whistleKey: whistleKey), .IV2)
        XCTAssertEqual(converter.pitchToFingering(79, whistleKey: whistleKey), .V2)
        XCTAssertEqual(converter.pitchToFingering(81, whistleKey: whistleKey), .VI2)
    }
    
    func testPitchToFingering_GWhistle_FirstOctave() {
        let whistleKey = WhistleKey.G
        
        XCTAssertEqual(converter.pitchToFingering(55, whistleKey: whistleKey), .I)
        XCTAssertEqual(converter.pitchToFingering(57, whistleKey: whistleKey), .II)
        XCTAssertEqual(converter.pitchToFingering(59, whistleKey: whistleKey), .III)
        XCTAssertEqual(converter.pitchToFingering(60, whistleKey: whistleKey), .IV)
        XCTAssertEqual(converter.pitchToFingering(62, whistleKey: whistleKey), .V)
        XCTAssertEqual(converter.pitchToFingering(64, whistleKey: whistleKey), .VI)
        XCTAssertEqual(converter.pitchToFingering(65, whistleKey: whistleKey), .flatVII)
        XCTAssertEqual(converter.pitchToFingering(66, whistleKey: whistleKey), .VII)
    }
    
    func testPitchToFingering_GWhistle_SecondOctave() {
        let whistleKey = WhistleKey.G
        
        XCTAssertEqual(converter.pitchToFingering(67, whistleKey: whistleKey), .I2)
        XCTAssertEqual(converter.pitchToFingering(69, whistleKey: whistleKey), .II2)
        XCTAssertEqual(converter.pitchToFingering(71, whistleKey: whistleKey), .III2)
        XCTAssertEqual(converter.pitchToFingering(72, whistleKey: whistleKey), .IV2)
        XCTAssertEqual(converter.pitchToFingering(74, whistleKey: whistleKey), .V2)
        XCTAssertEqual(converter.pitchToFingering(76, whistleKey: whistleKey), .VI2)
    }
    
    func testPitchToFingering_FlatVIIAndVII_AlwaysSame() {
        let whistleKey = WhistleKey.D
        
        XCTAssertEqual(converter.pitchToFingering(72, whistleKey: whistleKey), .flatVII)
        XCTAssertEqual(converter.pitchToFingering(73, whistleKey: whistleKey), .VII)
        
        let cWhistle = WhistleKey.C
        XCTAssertEqual(converter.pitchToFingering(70, whistleKey: cWhistle), .flatVII)
        XCTAssertEqual(converter.pitchToFingering(71, whistleKey: cWhistle), .VII)
    }
    
    func testPitchToFingering_AllWhistleKeys() {
        let testCases: [(WhistleKey, UInt8, WhistleScaleDegree)] = [
            (.Eb, 63, .I),
            (.D, 62, .I),
            (.Csharp, 61, .I),
            (.C, 60, .I),
            (.B, 59, .I),
            (.Bb, 58, .I),
            (.A, 57, .I),
            (.Ab, 56, .I),
            (.G, 55, .I),
            (.Fsharp, 66, .I),
            (.F, 65, .I),
            (.E, 64, .I),
        ]
        
        for (whistleKey, pitch, expectedDegree) in testCases {
            XCTAssertEqual(
                converter.pitchToFingering(pitch, whistleKey: whistleKey),
                expectedDegree,
                "Failed for \(whistleKey.displayName) whistle at pitch \(pitch)"
            )
        }
    }
    
    func testPitchToFingering_OctaveBoundary() {
        let whistleKey = WhistleKey.D
        
        XCTAssertEqual(converter.pitchToFingering(73, whistleKey: whistleKey), .VII)
        XCTAssertEqual(converter.pitchToFingering(74, whistleKey: whistleKey), .I2)
        
        let cWhistle = WhistleKey.C
        XCTAssertEqual(converter.pitchToFingering(71, whistleKey: cWhistle), .VII)
        XCTAssertEqual(converter.pitchToFingering(72, whistleKey: cWhistle), .I2)
    }
}

