import SwiftUI

extension LinearGradient {
    
    static func pinkHorizontal() -> LinearGradient {
        LinearGradient(
            colors: [Color.purple.opacity(0.6), Color.cyan.opacity(0.4)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static func blueHorizontal() -> LinearGradient {
        LinearGradient(
              colors: [
                  .fillPurple,
                  .fillLightBlue
              ],
              startPoint: .leading,
              endPoint: .trailing
          )
    }
    
    static func purpleDiagonal() -> LinearGradient {
        LinearGradient(
            colors: [
                .fillPurple,
                .fillBlue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func clear() -> LinearGradient {
        LinearGradient(
              colors: [Color.clear],
              startPoint: .leading,
              endPoint: .trailing
          )
    }
    
    static func lightBlueHorizontal() -> LinearGradient {
        LinearGradient(
            colors: [
                .fillBlue,
                .fillLightBlue
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    static func goldVertical() -> LinearGradient {
        LinearGradient(
            colors: [
                .fillGold,
                .bgPrimary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func orangeBlueHorizontal() -> LinearGradient {
        LinearGradient(
            colors: [
                .fillOrange,
                .fillBlueWater
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview(body: {
    Rectangle()
        .fill(LinearGradient.orangeBlueHorizontal())
        .frame(width: 170, height: 170)
        .background(.red)
        .shadow(radius: 1)
})
