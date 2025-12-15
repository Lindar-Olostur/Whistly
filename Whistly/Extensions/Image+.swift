import SwiftUI

extension Image {
    func standardImageStyle(isIcon: Bool = true, mode: ContentMode = .fit, width: CGFloat = .infinity, height: CGFloat = .infinity, color: Color? = nil) -> some View {
            self
                .resizable()
                .renderingMode(color == nil ? .original : .template)
                .foregroundStyle(color ?? .clear)
                .aspectRatio(contentMode: mode)
                .frame(maxWidth: isIcon ? 24 : width, maxHeight: isIcon ? 24 : height)
        }
}

