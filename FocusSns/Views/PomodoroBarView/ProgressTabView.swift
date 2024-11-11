//
//  MainTabView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI
import AudioToolbox

struct ProgressTabView: View {
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    var body: some View {
        let deviceTraitStatus = DeviceTraitStatus(hSizeClass: self.hSizeClass, vSizeClass: self.vSizeClass)

        ZStack {
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
