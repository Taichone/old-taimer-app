//
//  MainTabView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI
import AudioToolbox

// TODO: 休憩中であることを明示できるようにする
/*
 勉強時間を記録できるようにするのもあり。
 - Date を使って、無駄にタイマーを増やさない
 - 常に表示する or 停止したときに勉強時間がわかるようになる
 
 --- 具体的な計算方法（常時表示の場合は、毎分に増やすといいかも） ---
 -　前計算時の継続勉強時間 + （現在のDate - 格納された集中開始時のDate）
 
 */

struct ProgressTabView: View {
    //timeManagerクラスのインスタンスを作成(プロパティの値を参照するため、@EnvironmentObjectをつけて)
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    var body: some View {
        let deviceTraitStatus = DeviceTraitStatus(hSizeClass: self.hSizeClass, vSizeClass: self.vSizeClass)

        ZStack {
            // 止まってる時はピッカー表示・そうじゃない（動いてるとき・一時停止の）時はタイマー表示
            if timeManager.timerStatus == .stopped {
                PickerView()
            } else {
                if timeManager.isProgressBarOn {
                    switch deviceTraitStatus {
                    case .wRhR, .wRhC, .wChC:
                        HStack {
                            if timeManager.isTableClockViewOn {
                                TableClockView()
                            }
                            ProgressBarView()
                        }
                    case  .wChR:
                        VStack {
                            if timeManager.isTableClockViewOn {
                                TableClockView()
                            }
                            ProgressBarView()
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                ZStack {
                    if self.timeManager.isButtonViewOn == true {
                        ButtonsView()
                            .padding()
                    }
                }
            }
        }
    }
}
