import SwiftUI

struct PositionInfoSectionView: View {
    @Environment(MainContainer.self) private var viewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Beat")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(String(format: "%.1f", viewModel.sequencer.currentBeat))
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Measure")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(viewModel.sequencer.currentMeasure)/\(viewModel.sequencer.totalMeasures)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Tempo")
                    .font(.caption)
                    .foregroundColor(.gray)
                if let tune = viewModel.storage.loadedTune {
                    Text("\(Int(tune.tempo))")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.fillQuartenary)
        )
    }
}

#Preview {
    PositionInfoSectionView()
        .environment(MainContainer())
}




















