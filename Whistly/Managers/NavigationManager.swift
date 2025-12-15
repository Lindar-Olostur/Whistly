import SwiftUI

final class NavigationManager: ObservableObject {
    @MainActor let premium = PurchaseManager.shared
    @Published var screen: Screen = .splash
    @AppStorage("onboardingKey") var onCompleted = false
    @Published var openMainPaywall: Bool = false
    @Published var openSettings: Bool = false
   
    @MainActor func splashFinished() {
        if onCompleted {
            if premium.isSubscribed {
                withAnimation { screen = .main }
            } else {
                withAnimation { screen = .onboardingPaywall }
            }
        } else {
            withAnimation { screen = .onboarding }
        }
    }
    
    @MainActor func onboardingFinished() {
        onCompleted = true
        if premium.isSubscribed {
            withAnimation { screen = .main }
        } else {
            withAnimation { screen = .onboardingPaywall }
        }
    }
    
    @MainActor func goToScreen(_ screen: Screen) {
        withAnimation { self.screen = screen }
    }
}

enum Screen: Equatable {
    case splash, onboarding, onboardingPaywall, main
}


