import SwiftUI

extension Gradient {
    
    static func bgGlack(_ radius: CGFloat) -> RadialGradient {
        RadialGradient(gradient: Gradient.init(colors: [.gradientGray, .gradientBlack]), center: .center, startRadius: 0, endRadius: radius)
    }
    
    static func strokePrimary() -> LinearGradient {
        LinearGradient(colors: [.white, .clear, .white], startPoint: .init(x: 0.5, y: 0.3), endPoint: .init(x: 0.5, y: 0.7))
    }
    
    static func fillPinkLinear
    () -> LinearGradient {
        LinearGradient(colors: [.fillPinkLinear, .gradientWhite, .fillPinkLinear], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static func fillLinear(isBottom: Bool) -> LinearGradient {
        if isBottom {
            return LinearGradient(
                colors: [.clear, .fillLinear],
                startPoint: .init(x: 0.5, y: 1),
                endPoint: .init(x: 0.5, y: -2)
            )
        } else {
            return LinearGradient(
                colors: [.clear, .fillLinear],
                startPoint: .init(x: 0.5, y: 0),
                endPoint: .init(x: 0.5, y: 2)
            )
        }
    }
}

#Preview(body: {
    Rectangle()
        .fill(Gradient.fillPinkLinear())
        .frame(width: 170, height: 170)
        .background(.red)
        .shadow(radius: 1)
})
