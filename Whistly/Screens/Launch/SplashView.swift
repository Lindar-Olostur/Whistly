import SwiftUI

private struct _LaunchScreenContent: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController { UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()! }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct SplashView: View {
    @Environment(MainContainer.self) private var viewModel
    
    var body: some View {
        _LaunchScreenContent()
            .ignoresSafeArea()
            .onChange(of: viewModel.premium.products) {
                if viewModel.premium.paywall != nil {
                    viewModel.navigation.splashFinished()
                }
            }
    }
}

#Preview {
    SplashView()
        .environment(MainContainer())
}

