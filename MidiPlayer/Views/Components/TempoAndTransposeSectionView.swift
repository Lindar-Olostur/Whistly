//
//  TempoAndTransposeSectionView.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 30.11.2025.
//

import SwiftUI

struct TempoAndTransposeSectionView: View {
    @Binding var tempo: Double
    @Binding var transpose: Int
    let originalKey: String

    var body: some View {
        HStack(spacing: 20) {
            // Темп
            VStack(spacing: 4) {
                Text("Tempo")
                    .font(.caption2)
                    .foregroundColor(.gray)
                HStack {
                    Text("60")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    Slider(value: $tempo, in: 60...240, step: 1)
                        .tint(Color(red: 0.5, green: 0.6, blue: 0.9))
                    Text("240")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)

            // Транспонирование
            TransposeControl(
                transpose: $transpose,
                originalKey: originalKey
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TempoAndTransposeSectionView(
        tempo: .constant(120),
        transpose: .constant(0),
        originalKey: "C"
    )
}
