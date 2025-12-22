import SwiftUI

struct MeasureSelectorView: View {
    @Binding var startMeasure: Int
    @Binding var endMeasure: Int
    let totalMeasures: Int
    var loops: [MeasureLoop] = []
    var selectedLoopId: UUID?
    var onLoopSelect: ((MeasureLoop) -> Void)?
    var onLoopAdd: ((Int, Int) -> Void)?
    var onLoopRemove: ((UUID) -> Void)?
    
    @State private var showingAddLoop = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Measures")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("From")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            if startMeasure > 1 {
                                startMeasure -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.purple.opacity(0.8))
                        }
                        
                        Text("\(startMeasure)")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 40)
                        
                        Button(action: {
                            if startMeasure < endMeasure {
                                startMeasure += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.purple.opacity(0.8))
                        }
                    }
                }
                
                Text("—")
                    .foregroundColor(.gray)
                
                VStack(spacing: 4) {
                    Text("To")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            if endMeasure > startMeasure {
                                endMeasure -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.cyan.opacity(0.8))
                        }
                        
                        Text("\(endMeasure)")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(width: 40)
                        
                        Button(action: {
                            if endMeasure < totalMeasures {
                                endMeasure += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.cyan.opacity(0.8))
                        }
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if loops.isEmpty {
                        QuickSelectButton(title: "All") {
                            startMeasure = 1
                            endMeasure = totalMeasures
                        }
                    } else {
                        ForEach(loops) { loop in
                            LoopButton(
                                loop: loop,
                                isSelected: selectedLoopId == loop.id,
                                totalMeasures: totalMeasures,
                                onSelect: {
                                    onLoopSelect?(loop)
                                },
                                onRemove: loop.isDefault ? nil : {
                                    onLoopRemove?(loop.id)
                                }
                            )
                        }
                    }
                    
                    if onLoopAdd != nil {
                        Button(action: { showingAddLoop = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.green.opacity(0.8))
                                .frame(width: 32, height: 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [4]))
                                )
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
        .alert("Add Loop", isPresented: $showingAddLoop) {
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                onLoopAdd?(startMeasure, endMeasure)
            }
        } message: {
            Text("Add current range (\(startMeasure)-\(endMeasure)) as a new loop?")
        }
    }
}

struct QuickSelectButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                )
        }
    }
}
struct LoopButton: View {
    let loop: MeasureLoop
    let isSelected: Bool
    let totalMeasures: Int
    var onSelect: () -> Void
    var onRemove: (() -> Void)?
    
    private var backgroundColor: LinearGradient {
        if isSelected {
            return LinearGradient.primary
        }
        
        switch loop.loopType {
        case .segment:
            return LinearGradient(
                colors: [Color.white.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .half:
            return LinearGradient(
                colors: [Color.blue.opacity(0.2), Color.cyan.opacity(0.15)],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .full:
            return LinearGradient(
                colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.15)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 4) {
                Text(loop.startMeasure == 1 && loop.endMeasure >= totalMeasures ? "All" : "\(loop.startMeasure)-\(loop.endMeasure)")
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                
                if let onRemove = onRemove {
                    Button(action: onRemove) {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.red.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
        }
        .buttonStyle(.plain)
    }
}
