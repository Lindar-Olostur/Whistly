//
//  OrientationService.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 30.11.2025.
//
import SwiftUI

#if os(iOS)
import UIKit
#endif

@Observable
class OrientationService {
    #if os(iOS)
    var currentOrientation: UIDeviceOrientation = {
        let deviceOrientation = UIDevice.current.orientation
        if deviceOrientation != .unknown {
            return deviceOrientation
        }

        let screenSize = UIScreen.main.bounds.size
        return screenSize.width > screenSize.height ? .landscapeLeft : .portrait
    }()
    var isRotationEnabled = true

    var isPortrait: Bool {
        switch currentOrientation {
        case .portrait, .portraitUpsideDown:
            return true
        case .landscapeLeft, .landscapeRight:
            return false
        default:
            let screenSize = UIScreen.main.bounds.size
            return screenSize.width <= screenSize.height
        }
    }

    func setupOrientationObserver() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()

        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let newOrientation = UIDevice.current.orientation
            if newOrientation != .unknown {
                self.currentOrientation = newOrientation
            }
        }
    }
    
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    #else
    var isPortrait: Bool {
        return true
    }
    
    func setupOrientationObserver() {
    }
    
    func removeOrientationObserver() {
    }
    #endif
}
