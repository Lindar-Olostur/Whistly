import SwiftUI

struct TuneAndWhistleSectionView: View {
    @Binding var whistleKey: WhistleKey
    let playableKeys: [String]
    let currentTuneKey: String
    let currentDisplayedKey: String
    let onKeySelect: (String) -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                WhistleKeyPicker(isMenu: true, whistleKey: $whistleKey)

                if !playableKeys.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(playableKeys, id: \.self) { key in
                                Button(action: {
                                    onKeySelect(key)
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
                    Text("Нет доступных тональностей")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
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
    @Previewable @State var key: WhistleKey = .D
    TuneAndWhistleSectionView(
        whistleKey: $key,
        playableKeys: ["C", "D", "G", "A"],
        currentTuneKey: "C",
        currentDisplayedKey: "C",
        onKeySelect: { _ in }
    )
    .frame(width: 400)
}
