//
//  AppDelegate.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 30.11.2025.
//


import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    static var lockedOrientation: UIDeviceOrientation = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
