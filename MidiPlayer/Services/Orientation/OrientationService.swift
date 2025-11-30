//
//  OrientationService.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 30.11.2025.
//
import SwiftUI

@Observable
class OrientationService {
    var currentOrientation = UIDeviceOrientation.portrait
    var isRotationEnabled = true
    
    func setupOrientationObserver() {
        NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.currentOrientation = UIDevice.current.orientation
        }
    }
    
    func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
}
