//
//  Data.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

enum TimeFormat {
    case hr
    case min
    case sec
}

// タイマーが動いているか、一時停止か、完全停止か
enum TimerStatus {
    case running
    case pause
    case stopped
}

// 休憩時間中か、集中時間中か
enum TimerRunMode {
    case focus
    case rest
}

// タスクの優先度
enum TaskPriority {
    case high
    case medium
    case low
}

// デバイスの向き
enum DeviceTraitStatus {
    case wRhR
    case wChR
    case wRhC
    case wChC

    init(hSizeClass: UserInterfaceSizeClass?, vSizeClass: UserInterfaceSizeClass?) {

        switch (hSizeClass, vSizeClass) {
        case (.regular, .regular):
            self = .wRhR
        case (.compact, .regular):
            self = .wChR
        case (.regular, .compact):
            self = .wRhC
        case (.compact, .compact):
            self = .wChC
        default:
            self = .wChR
        }
    }
}

// Task型 (Swiftのほとんどの型は構造体でできている)
struct Task: Identifiable {
    // 各タスクに一意の識別子を与えるUUID
    var id: String = UUID().uuidString
    var title: String
    var notes: String
    var priority: TaskPriority
    var completed: Bool
}
