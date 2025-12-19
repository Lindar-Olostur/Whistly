import AdServices
import ApphudSDK
import ApphudBase
import SwiftUI
import Observation

@Observable
@MainActor
final class PurchaseManager {
    var paywall: ApphudPaywall!
    var products: [ApphudProduct] = []
    var isSubscribed: Bool = false
    var trialProduct: ApphudProduct!
    var nonTrialProduct: ApphudProduct!
    var lifetimeProduct: ApphudProduct!
    
    static var shared = PurchaseManager()
    
    private init() {
        Apphud.configure(apiKey: apphudKey)
        Task {
            let paywalls = await Apphud.fetchedPaywallsWithFallback()
            self.configure(with: paywalls)
        }
        
#if DEBUG
        self.isSubscribed = true
#else
        self.isSubscribed = Apphud.hasPremiumAccess()
#endif
    }
    
    private func configure(with paywalls: [ApphudPaywall]) {
        paywall = paywalls.first(where: { $0.identifier == paywallName })
        nonTrialProduct = paywall.products.first(where: { !$0.isTrial })
        trialProduct = paywall.products.first(where: { $0.isTrial })
        lifetimeProduct = paywall.products.first(where: { $0.isLifetime })
        products = paywall.products
    }
    
    func product(for type: ProductType) -> ApphudProduct! {
        switch type {
        case .weekTrial:
            return trialProduct
        case .weekNonTrial:
            return nonTrialProduct
        case .lifetime:
            return lifetimeProduct
        }
    }

    func makePurchase(product: ApphudProduct, completion: @escaping (Bool) -> Void) {
        Task { @MainActor in
            let result = await Apphud.fallbackPurchase(product: product)
            self.isSubscribed = result
            completion(result)
        }
    }

    func restorePurchase(completion: @escaping (Bool) -> Void) {
        Task { @MainActor in
            let result = await Apphud.fallbackRestore()
            self.isSubscribed = result
            completion(result)
            return
        }
    }
}

