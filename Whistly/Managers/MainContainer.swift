
import Observation

@Observable
final class MainContainer {
    @MainActor var premium = PurchaseManager.shared
    var navigation = NavigationManager()
}
