import SwiftUI

struct TempoSectionView: View {
    @Environment(MainContainer.self) private var viewModel
    private var tempo: Double {
        viewModel.storage.loadedTune?.tempo ?? viewModel.sequencer.tempo
    }

    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("Tempo")
                    .font(.caption2)
                    .foregroundColor(.gray)
                HStack {
                    Text("60")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    Slider(value: Binding(
                        get: { tempo },
                        set: { tempo in
                            viewModel.storage.updateLoadedTune { tune in
                                viewModel.sequencer.tempo = tempo
                                tune.tempo = tempo
                            }
                        }), in: 60...240, step: 1)
                        .tint(Color(red: 0.5, green: 0.6, blue: 0.9))
                    Text("240")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TempoSectionView()
        .environment(MainContainer())
}


