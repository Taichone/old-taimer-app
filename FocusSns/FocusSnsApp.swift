//
//  FocusSnsApp.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.

import SwiftUI

@main
struct FocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TimeManager())
                .environmentObject(ClockManager())
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
