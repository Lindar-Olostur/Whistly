//
//  HeaderSectionView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 30.11.2025.
//

import SwiftUI

struct HeaderSectionView: View {
    let tuneName: String?
    @Binding var sourceType: SourceType
    let onSourceChange: (SourceType) -> Void
    var onImportTap: (() -> Void)?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Whistly")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient.orangeBlueHorizontal()
                    )

                if let tune = tuneName {
                    Text(tune)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Кнопка импорта
            if let onImportTap = onImportTap {
                Button(action: onImportTap) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

#Preview {
    HeaderSectionView(
        tuneName: "Test Tune",
        sourceType: .constant(.midi),
        onSourceChange: { _ in },
        onImportTap: nil
    )
}




