//
//  SettingTabView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

struct SettingTabView: View {
    //モーダルシートを利用するためのプロパティ
    //    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var clockManager: ClockManager
    
    var body: some View {
        Form {
            Section(header: Text("タイマー関連設定")) {
                Toggle(isOn: self.$timeManager.isAlarmOn) {
                    Text("通知音を鳴らす")
                }
                if self.timeManager.isAlarmOn == false {
                    Toggle(isOn: self.$timeManager.isVibrationOn) {
                        Text("バイブレーションで通知する")
                    }.onDisappear(perform: {
                        self.timeManager.isVibrationOn = false
                        print("Debug_____isVibrationOn == false")
                    })
                }
                if self.timeManager.isAlarmOn || self.timeManager.isVibrationOn {
                    Toggle(isOn: self.$timeManager.notifyOnlyEndOfFocus) {
                        Text("休憩終了時のみ通知する")
                    }
                }
                Toggle(isOn: self.$timeManager.isTimerViewOn) {
                    Text("タイマーの残り時間を表示する")
                }
                Toggle(isOn: self.$timeManager.manuallyStartBreak) {
                    Text("休憩を手動で開始する")
                }
                Toggle(isOn: self.$timeManager.powerSavingMode) {
                    Text("省電力モード")
                }.onChange(of: self.timeManager.powerSavingMode, perform: { _ in self.timeManager.setRefreshCycle() })
            }
            Section(header: Text("時計関連設定")) {
                Toggle(isOn: self.$timeManager.isTableClockViewOn) {
                    Text("タイマー画面に時計を表示する")
                }
            }
            Section(header: Text("カスタマイズ")) {
                ColorPicker("メインカラー", selection: self.$timeManager.mainColor).onChange(of: self.timeManager.mainColor, perform: { _ in self.timeManager.setUserColors() })
                ColorPicker("サブカラー", selection: self.$timeManager.subColor).onChange(of: self.timeManager.subColor, perform: { _ in self.timeManager.setUserColors() })
            }
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView().environmentObject(TimeManager())
    }
}
