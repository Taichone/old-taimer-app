//
//  TimeManager.swift
//  FocusSns
//
//  Created by Taichi on 2021/12/11.
//

import SwiftUI
import AudioToolbox

class TimeManager: ObservableObject {

    let soundID: SystemSoundID = 1002
    let impactLight = UIImpactFeedbackGenerator(style: .light) // .impactOccurred() で発動
    
// MARK: ユーザー設定
    @AppStorage(wrappedValue: false, "isAlarmOn") var isAlarmOn: Bool
    @AppStorage(wrappedValue: true, "isVibrationOn") var isVibrationOn: Bool
    @AppStorage(wrappedValue: false, "notifyOnlyEndOfFocus") var notifyOnlyEndOfFocus: Bool
    @AppStorage(wrappedValue: false, "isTimerViewOn") var isTimerViewOn: Bool
    @AppStorage(wrappedValue: false, "isTableClockViewOn") var isTableClockViewOn: Bool
    @AppStorage(wrappedValue: false, "manuallyStartBreak") var manuallyStartBreak: Bool
    @AppStorage(wrappedValue: false, "powerSavingMode") var powerSavingMode: Bool
    @Published var mainColor: Color = Color(red: 0, green: 1, blue: 0.8)
    @Published var subColor: Color = Color(red: 1, green: 0, blue: 0.5)
    
// MARK: ポモドーロタイマー駆動関連プロパティ
    @AppStorage(wrappedValue: 0, "hourFocusSelection") var hourSelection: Int
    @AppStorage(wrappedValue: 25, "minFocusSelection") var minSelection: Int
    @AppStorage(wrappedValue: 0, "secFocusSelection") var secSelection: Int
    @AppStorage(wrappedValue: 0, "hourRestSelection") var hourRestSelection: Int
    @AppStorage(wrappedValue: 5, "minRestSelection") var minRestSelection: Int
    @AppStorage(wrappedValue: 0, "secRestSelection") var secRestSelection: Int
    
    @AppStorage(wrappedValue: 0, "maxFocusValue") var maxFocusValue: Int
    @AppStorage(wrappedValue: 0, "maxRestValue") var maxRestValue: Int
    
    @Published var duration: Double = 0

    var displayedTimeFormat: TimeFormat = .min
    @Published var timerStatus: TimerStatus = .stopped
    var timerRunMode: TimerRunMode = .focus
    
    var refreshCycle: Double = 10000
    var timer = Timer.publish(every: 10000, on: .main, in: .common).autoconnect()
    
// MARK: View 表示
    @Published var isProgressBarOn: Bool = true
    @Published var isButtonViewOn: Bool = true
    
// MARK: ライフサイクル
    init() {
        self.getUserColors()
    }
    
// MARK: UserDefaluts
    private func getUserColors() {
        self.mainColor = UserDefaults.standard.data(forKey: "mainColor")?.convertToColor() ?? Color(red: 0, green: 1, blue: 0.8)
        self.subColor = UserDefaults.standard.data(forKey: "subColor")?.convertToColor() ?? Color(red: 1, green: 0, blue: 0.5)
    }
    
    func setUserColors() {
        if let mainColorData = self.mainColor.convertToData() { UserDefaults.standard.set(mainColorData, forKey: "mainColor") }
        if let subColorData = self.subColor.convertToData() { UserDefaults.standard.set(subColorData, forKey: "subColor") }
    }
    
// MARK: バックグラウンド処理関連
    
    func storeTimerValueWhenClose() {
        if self.timerStatus == .running {
            UserDefaults.standard.set(Date(), forKey: "suspendDate") // 現在時刻を保存
            UserDefaults.standard.set(Int(self.duration), forKey: "duration") // 残り時間を保存
            UserDefaults.standard.set(self.timerRunMode == .focus, forKey: "timerRunModeIsFocus")
        }
    }
    
    func setTimerValueWhenOpen() {
        if let interval = self.getIntervalFromSuspend(),
           let isFocus = UserDefaults.standard.object(forKey: "timerRunModeIsFocus") as? Bool,
           let dura = UserDefaults.standard.object(forKey: "duration") as? Int {
            
            // 次回起動時にあってはいけない UserDefaults を削除
            UserDefaults.standard.removeObject(forKey: "suspendDate")
            UserDefaults.standard.removeObject(forKey: "duration")
            UserDefaults.standard.removeObject(forKey: "timerRunModeIsFocus")
            
            let amari = interval % (self.maxFocusValue + self.maxRestValue)
            
            if isFocus {
                switch amari {
                case 0..<dura:
                    self.timerRunMode = .focus
                    self.duration = Double(dura - amari)
                case dura..<(dura + self.maxRestValue):
                    self.timerRunMode = .rest
                    self.duration = Double(self.maxRestValue - amari + dura)
                case (dura + self.maxRestValue)..<(self.maxRestValue + self.maxFocusValue - dura):
                    self.timerRunMode = .focus
                    self.duration = Double(self.maxFocusValue - amari + dura + maxRestValue)
                default:
                    print("===タイマー値セットのエラー")
                }
            } else {
                switch amari {
                case 0..<dura:
                    self.timerRunMode = .rest
                    self.duration = Double(dura - amari)
                case dura..<(dura + self.maxFocusValue):
                    self.timerRunMode = .focus
                    self.duration = Double(self.maxFocusValue - amari + dura)
                case (dura + self.maxFocusValue)..<(self.maxFocusValue + self.maxRestValue - dura):
                    self.timerRunMode = .rest
                    self.duration = Double(self.maxRestValue - amari + dura + maxFocusValue)
                default:
                    print("===タイマー値セットのエラー")
                }
            }
        }
        
        // 次回起動時にあってはいけない UserDefaults を削除
        UserDefaults.standard.removeObject(forKey: "suspendDate")
        UserDefaults.standard.removeObject(forKey: "duration")
        UserDefaults.standard.removeObject(forKey: "timerRunModeIsFocus")
    }
    
    private func getIntervalFromSuspend() -> Int? {
        if let suspendDate = UserDefaults.standard.object(forKey: "suspendDate") as? Date {
            return Int(Date().timeIntervalSince(suspendDate))
        }
        return nil
    }
    
// MARK: ポモドーロタイマー駆動関連メソッド
    func setTimer() {
        self.maxFocusValue = self.hourSelection * 3600 + self.minSelection * 60 + self.secSelection
        self.maxRestValue  = self.hourRestSelection * 3600 + self.minRestSelection * 60 + self.secRestSelection
        
        self.setRefreshCycle()
        switch self.timerRunMode {
        case .focus:
            self.duration = Double(self.maxFocusValue)
        case .rest:
            self.duration = Double(self.maxRestValue)
        }
        
        switch self.duration {
        case 0..<60:
            self.displayedTimeFormat = .sec
        case 60..<3600:
            self.displayedTimeFormat = .min
        default:
            self.displayedTimeFormat = .hr
        }
    }
    
    // リフレッシュレートを司る
    private func setRefreshCycle(withMaxValue max: Int) {
        self.refreshCycle = { () -> Double in
             if self.powerSavingMode { return 1.0 }
            
            switch max {
            case 0..<11:
                return 0.01
            case 10..<31:
                return 0.02
            case 31..<91:
                return 0.05
            case 91..<301:
                return 0.1
            case 301..<1201:
                return 0.2
            case 1201..<1501:
                return 0.25
            case 1501..<3601:
                return 0.5
            default:
                return 1
            }
        }()
        
        self.timer = Timer.publish(every: self.refreshCycle, on: .main, in: .common).autoconnect()
    }
    
    private func setRefreshCycle(to newCycle: Double) {
        self.refreshCycle = newCycle
        self.timer = Timer.publish(every: self.refreshCycle, on: .main, in: .common).autoconnect()
    }
    
    func setRefreshCycle() {
        if self.powerSavingMode {
            self.refreshCycle = 1.0
            self.timer = Timer.publish(every: self.refreshCycle, on: .main, in: .common).autoconnect()
            return
        }
        
        switch self.timerRunMode {
        case .focus:
            self.setRefreshCycle(withMaxValue: self.maxFocusValue)
        case .rest:
            self.setRefreshCycle(withMaxValue: self.maxRestValue)
        }
    }
    
    func displayTimer() -> String {
        // 残り時間 (ceil(Double) で切上の値を表示)
        let hr = Int(ceil(self.duration)) / 3600
        let min = Int(ceil(self.duration)) % 3600 / 60
        let sec = Int(ceil(self.duration)) % 3600 % 60
        
        // 適切なフォーマットを返す
        switch displayedTimeFormat {
        case .hr:
            return String(format: hr >= 10 ? "%02d:%02d:%02d" : "%01d:%02d:%02d", hr, min, sec)
        case .min:
            return String(format: min >= 10 ? "%02d:%02d" : "%01d:%02d", min, sec)
        case .sec:
            return String(format: sec >= 10 ? "%02d" : "%01d", sec)
        }
    }
    
    // 集中と休憩を切り替え
    func changeTimerRunMode() {
        switch self.timerRunMode {
        case .focus:
            self.timerRunMode = .rest
            self.setTimer()
        case .rest:
            self.timerRunMode = .focus
            self.setTimer()
        }
    }
    
    func start() {
        self.timerStatus = .running
        UIApplication.shared.isIdleTimerDisabled = true
        setRefreshCycle()
        // 3秒の遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.timerStatus == .running {
                self.isButtonViewOn = false
            }
        }
    }
    
    func pause() {
        self.timerStatus = .pause
        // 一時停止時は、一旦省電力設定にしておく
        self.setRefreshCycle(to: 10000)
        self.isButtonViewOn = true
    }
    
    func reset() {
        self.timerStatus = .stopped
        self.isButtonViewOn = true
        //残り時間を強制的に0に
        self.duration = 0
    }
}




