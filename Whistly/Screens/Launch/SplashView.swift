import SwiftUI

private struct _LaunchScreenContent: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()! }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct SplashView: View {
    @EnvironmentObject var premium: PurchaseManager
    @EnvironmentObject var router: NavigationManager
    
    var body: some View {
        _LaunchScreenContent()
            .ignoresSafeArea()
            .onReceive(premium.$products) { array in
                if premium.paywall != nil {
                    router.splashFinished()
                }
            }
    }
}

#Preview {
    SplashView()
        .environmentObject(PurchaseManager.shared)
        .environmentObject(NavigationManager())
}

