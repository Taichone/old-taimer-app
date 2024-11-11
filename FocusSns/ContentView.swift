//
//  ContentView.swift
//  FocusApp
//
//  Created by Rita on 2021/08/22.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var clockManager: ClockManager
    @Environment(\.scenePhase) private var scenePhase
    
    @State var selectedTag = 2
    
    var body: some View {
        TabView(selection: $selectedTag){
            TableClockView()
                .ignoresSafeArea()
                .onAppear(perform: {
                    UIApplication.shared.isIdleTimerDisabled = true
                })
                .tabItem{
                    Image(systemName: "clock")
                }.tag(1)
            ProgressTabView()
                .onTapGesture {
                    if !self.timeManager.isButtonViewOn {
                        self.timeManager.impactLight.impactOccurred()
                    }
                    self.timeManager.isButtonViewOn = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if self.timeManager.timerStatus == .running {
                            self.timeManager.isButtonViewOn = false
                        }
                    }
                }
                .onAppear(perform: {
                    UIApplication.shared.isIdleTimerDisabled = true
                })
                .tabItem{
                    Image(systemName: "timer")
                }.tag(2)
            SettingTabView()
                .tabItem{
                    Image(systemName: "gear")
                }.tag(3)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                self.timeManager.storeTimerValueWhenClose()
            case .inactive:
                print("")
            case .active:
                self.timeManager.setTimerValueWhenOpen()
            @unknown default:
                fatalError()
            }
        }
        .onReceive(self.clockManager.timer) { _ in
            self.clockManager.currentHour = Calendar.current.component(.hour, from: Date())
            self.clockManager.currentMinute = Calendar.current.component(.minute, from: Date())
            self.clockManager.currentSecond = Calendar.current.component(.second, from: Date())
        }
        
        // ZStackUI自体に対するモディファイア.onReceive
        // 指定した時間（1秒）ごとに発動するtimerをトリガーにしてクロージャ内のコードを実行
        .onReceive(self.timeManager.timer) { _ in
            // タイマーステータスが.running以外の場合何も実行しない
            guard self.timeManager.timerStatus == .running else { return }
            switch self.timeManager.timerRunMode {
            case .focus:
                if self.timeManager.duration > 0 {
                    self.timeManager.duration -= self.timeManager.refreshCycle
                } else {
                    self.timeManager.changeTimerRunMode()
                    
                    if !self.timeManager.notifyOnlyEndOfFocus {
                        if self.timeManager.isAlarmOn {
                            AudioServicesPlayAlertSoundWithCompletion(self.timeManager.soundID, nil)
                        }
                        if self.timeManager.isVibrationOn {
                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                        }
                    }
                    // 休憩を手動で開始する場合は pause
                    if self.timeManager.manuallyStartBreak {
                        self.timeManager.pause()
                    }
                }
            case .rest:
                if self.timeManager.duration > 0 {
                    self.timeManager.duration -= self.timeManager.refreshCycle
                } else {
                    self.timeManager.changeTimerRunMode()
                    if self.timeManager.isAlarmOn {
                        AudioServicesPlayAlertSoundWithCompletion(self.timeManager.soundID, nil)
                    }
                    if self.timeManager.isVibrationOn {
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TimeManager()).environmentObject(ClockManager())
    }
}
