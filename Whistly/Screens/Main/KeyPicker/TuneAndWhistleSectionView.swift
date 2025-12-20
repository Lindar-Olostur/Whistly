import SwiftUI

struct TuneAndWhistleSectionView: View {
    @Environment(MainContainer.self) private var viewModel
    let converter = WhistleConverter()
    private var loadedTune: TuneModel? {
        viewModel.storage.loadedTune
    }
    
    private var whistleKey: WhistleKey {
        loadedTune?.whistleKey ?? viewModel.userSettings.defaultWhistleKey
    }
    
    private var currentTuneKey: String {
        loadedTune?.detectedKey ?? ""
    }
    
    private var currentDisplayedKey: String {
        loadedTune?.selectedKey ?? loadedTune?.detectedKey ?? ""
    }
    
    private var playableKeys: [String] {
        guard let originalInfo = viewModel.sequencer.originalTuneInfo,
              !currentTuneKey.isEmpty else {
            return []
        }
        return converter.findPlayableKeys(
            for: originalInfo.allNotes,
            whistleKey: whistleKey,
            baseKey: currentTuneKey
        )
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                WhistleKeyPicker(
                    isMenu: true,
                    whistleKey: Binding(
                        get: { whistleKey },
                        set: { newKey in
                            viewModel.storage.updateLoadedTune { tune in
                                tune.whistleKey = newKey
                            }
                        }
                    )
                )

                if !playableKeys.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(playableKeys, id: \.self) { key in
                                Button(action: {
                                    viewModel.storage.updateLoadedTune { tune in
                                        tune.selectedKey = key
                                    }
                                }) {
                                    Text(key)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(key == currentDisplayedKey ? .accentTertiary : .textSecondary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 13)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(key == currentDisplayedKey ? Color.orange.opacity(0.2) : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .frame(height: 30)
                } else {
                    Text("There are no suitable keys")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.05))
                        )
                        .frame(height: 30)
                }

                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Previewable @State var viewModel = MainContainer()
        TuneAndWhistleSectionView()
            .frame(width: 400)
            .environment(viewModel)
            .onAppear {
                if let tune = viewModel.storage.tunesCache.first {
                    viewModel.storage.loadedTune = tune
                }
            }
    .frame(width: 400)
    .environment(MainContainer())
}
