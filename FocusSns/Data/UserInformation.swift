//
//  UserInformation.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//
// ユーザの情報を握る、最も重要なクラス

import Foundation

// いらんかも
class UserInformation: ObservableObject {
    // Task型の配列をユーザーのtaskリストとする
    @Published var taskList = [
        Task(title: "SwiftUI無双開発術入門", notes: "14章", priority: .medium, completed: false),
        Task(title: "TOEIC虹のフレーズ", notes: "101-200", priority: .medium, completed: false),
        Task(title: "エル英文法", notes: "14章", priority: .medium, completed: false),
        Task(title: "Swift実践究極", notes: "14章", priority: .medium, completed: false)
    ]
}

// デバッグ用の初期値
let testDataTasks = [
    Task(title: "英単語帳", notes: "101-200", priority: .medium, completed: false),
    Task(title: "買い物", notes: "魚・肉・豆腐・ネギ", priority: .medium, completed: false),
    Task(title: "洗濯", notes: "ドライコース", priority: .medium, completed: false),
    Task(title: "お散歩", notes: "30分間歩く", priority: .medium, completed: false)
]
