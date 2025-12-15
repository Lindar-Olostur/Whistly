import ApphudSDK
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var router: NavigationManager
    enum OBScreen: Int, CaseIterable {
        case first, second, third
        
        var next: OBScreen? {
            let all = Self.allCases
            guard let index = all.firstIndex(of: self), index + 1 < all.count else {
                return nil
            }
            return all[index + 1]
        }
    }
    @State var isRestoring = false
    @State var obStep = OBScreen.first
    let titles = ["Compress\nyour media", "Loved by\nour users", "Advanced\ncompression tools"]
    let subtitles = ["Easily compress photos, videos, or both\nat the same time to save space", "Thousands of users trust our app to keep\ntheir devices clutter-free and fast", "Customize resolution, bitrate, and\nformats to get perfect results every time"]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                    Group {
                        Text(titles[obStep.rawValue])
                            .styled(as: .title1)
                            .fixedSize()
                            .padding(.top, 4)
                        Text(subtitles[obStep.rawValue])
                            .styled(as: .body)
                    }
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize()
                    
                    BigButton() {
                        withAnimation {
                            if let nextStep = obStep.next {
                                obStep = nextStep
                            } else {
                                router.onboardingFinished()
                            }
                        }
                    } label: {
                        Text("Continue").styled(as: .button)
                    }
                    OBFooterView(isRestoring: .constant(false))
            }
            .frame(maxWidth: UIDevice.isIPad ? 464 : .infinity)
            .padding(16)
            .background(.fillTertiary)
            .clipShape(RoundedCorner(radius: 26, corners: [.topLeft, .topRight]))
        }
        .background {
            Group {
                switch obStep {
                case .first: Image(.ob1)
                        .resizable()
                        .scaledToFill()
                case .second:
                    Image(.ob2)
                        .resizable()
                        .scaledToFill()
                case .third:
                    Image(.ob3)
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
        .environmentObject(NavigationManager())
}

