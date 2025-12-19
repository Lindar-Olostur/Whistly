import SwiftUI

struct WhistleKeyPicker: View {
    var isMenu = true
    @Binding var whistleKey: WhistleKey
    
    var body: some View {
        HStack(spacing: 6) {
//            if !isMenu {
//                Button(action: {
//                    let keys = WhistleKey.allCases
//                    if let index = keys.firstIndex(of: whistleKey) {
//                        if index > 0 {
//                            whistleKey = keys[index - 1]
//                        } else {
//                            whistleKey = keys[keys.count - 1]
//                        }
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(.cyan.opacity(0.7))
//                }
//            }
            Menu {
                ForEach(WhistleKey.allCases, id: \.self) { key in
                    Button(action: {
                        whistleKey = key
                    }) {
                        HStack {
                            Text(key.displayName)
                            if whistleKey == key {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                VStack(spacing: 0) {
                    Text(whistleKey.displayName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.accent)
                    Text("whistle")
                        .font(.system(size: 8))
                        .foregroundColor(.textSecondary)
                }
                .frame(minWidth: 50)
            }

//            if !isMenu {
//                Button(action: {
//                    let keys = WhistleKey.allCases
//                    if let index = keys.firstIndex(of: whistleKey) {
//                        if index < keys.count - 1 {
//                            whistleKey = keys[index + 1]
//                        } else {
//                            whistleKey = keys[0]
//                        }
//                    }
//                }) {
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 10, weight: .bold))
//                        .foregroundColor(.cyan.opacity(0.7))
//                }
//            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.fillQuartenary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.accentSecondary.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

#Preview {
    @Previewable @State var key: WhistleKey = .D
    WhistleKeyPicker(isMenu: true, whistleKey: $key)
        .scaleEffect(4)
}
