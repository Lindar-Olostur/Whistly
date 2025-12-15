import SwiftUI

extension LinearGradient {
    static var primary: LinearGradient {
        LinearGradient(
            colors: [.gradient1, .gradient2],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

