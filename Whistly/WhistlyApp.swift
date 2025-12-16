import SwiftUI

@main
struct WhistlyApp: App {
    @State var viewModel = MainContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(viewModel)
        }
    }
}
