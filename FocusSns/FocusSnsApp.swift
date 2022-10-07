//
//  FocusSnsApp.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
// 表示App名はプロジェクトファイルの info -> Bundle display name から変更

import SwiftUI

@main
struct FocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            // SceneDelegate.swift の代わりとして仮定
            // 最初に表示したいビューを書く (存在する@EnvironmentObjectはここに追記しないといけない)
            ContentView()
                .environmentObject(TimeManager())
                .environmentObject(ClockManager())
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // この間に AppDelegate.swift の処理を書く。
        return true
    }
}
