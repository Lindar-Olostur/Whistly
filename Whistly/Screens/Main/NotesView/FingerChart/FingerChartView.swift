import SwiftUI

enum ChartScale {
    case landscape, portrait
    
    var fingeringRowHeight: CGFloat {
        switch self {
        case .portrait: 90
        case .landscape: 150
        }
    }
}

struct FingerChartView: View {
    @Environment(MainContainer.self) private var viewModel
    let midiInfo: MIDIFileInfo
    var currentBeat: Double {
        viewModel.sequencer.currentBeat
    }
    var startMeasure: Int {
        viewModel.sequencer.startMeasure
    }
    var endMeasure: Int {
        viewModel.sequencer.endMeasure
    }
    var isPlaying: Bool {
        viewModel.sequencer.isPlaying
    }
    var whistleKey: WhistleKey 
    
    // Настройки
    var mode: ChartScale = .portrait
    private let pianoKeyWidth: CGFloat = 35
    
    private var visibleNotes: [MIDINote] {
        let startBeat = Double(startMeasure - 1) * Double(midiInfo.beatsPerMeasure)
        let endBeat = Double(endMeasure) * Double(midiInfo.beatsPerMeasure)
        return midiInfo.allNotes.filter { note in
            note.endBeat > startBeat && note.startBeat < endBeat
        }
    }
    
    private var visibleBeats: Double {
        Double((endMeasure - startMeasure + 1) * midiInfo.beatsPerMeasure)
    }
    
    private var startBeatOffset: Double {
        Double((startMeasure - 1) * midiInfo.beatsPerMeasure)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - pianoKeyWidth
            let baseWidth = availableWidth / CGFloat(visibleBeats)
            let totalContentWidth = CGFloat(visibleBeats) * baseWidth
            
            FingeringRowView(
                notes: visibleNotes,
                currentBeat: currentBeat,
                startBeatOffset: startBeatOffset,
                beatWidth: baseWidth,
                rowHeight: mode.fingeringRowHeight,
                totalWidth: totalContentWidth,
                offset: 0,
                isPlaying: isPlaying,
                whistleKey: whistleKey
            )
//                    .frame(height: mode.fingeringRowHeight)
            .clipped()
        }
        .frame(maxHeight: 110)
//        .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    if let url = Bundle.main.url(forResource: "silverspear", withExtension: "mid"),
       let info = MIDIParser.parse(url: url) {
        FingerChartView(midiInfo: info, whistleKey: .D)
        .environment(MainContainer())
    }
}
