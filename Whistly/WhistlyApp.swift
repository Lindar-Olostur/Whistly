//
//  WhistlyApp.swift
//  Whistly
//
//  Created by Lindar Olostur on 13.12.2025.
//

import SwiftUI

@main
struct WhistlyApp: App {
    @StateObject var premium = PurchaseManager.shared
    @StateObject var navigation = NavigationManager()
    @StateObject var permissions = PermissionsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(permissions)
                .environmentObject(navigation)
                .environmentObject(premium)
        }
    }
}
