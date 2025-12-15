import ApphudSDK
import ApphudBase

enum ProductType {
    case weekTrial, weekNonTrial, lifetime
}

extension ApphudProduct {
    func getProductType() -> ProductType {
        if isLifetime {
            return .lifetime
        } else {
            if isTrial {
                return .weekTrial
            } else {
                return .weekNonTrial
            }
        }
    }
    
    var fullPrice: String {
        var price = localizedPrice
        if isLifetime {
            price += " at once"
        } else {
            if isTrial {
                if let localizedSubscriptionPeriod {
                    price += "/\(localizedSubscriptionPeriod) + 3 days free trial"
                }
            } else {
                if let localizedSubscriptionPeriod {
                    price += "/\(localizedSubscriptionPeriod)"
                }
            }
        }
        return price
    }
}

