//
//  MidiPlayerApp.swift
//  MidiPlayer
//
//  Created by Lindar Olostur on 27.11.2025.
//

import SwiftUI

@main
struct MidiPlayerApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #elseif os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
