import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.name.lowercased().contains("ipad")
    }
}

