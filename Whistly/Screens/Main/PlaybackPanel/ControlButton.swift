import SwiftUI

struct ControlButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.fillQuartenary)
                    .frame(width: 44, height: 44)
                
                Image(systemName: systemName)
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

#Preview {
    ControlButton(systemName: "person", size: 17, action: {})
}
