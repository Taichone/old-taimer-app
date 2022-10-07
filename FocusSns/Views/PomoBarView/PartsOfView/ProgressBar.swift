//
//  ProgressBar.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

struct ProgressBarView: View {
    @EnvironmentObject var timeManager: TimeManager
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let shortSide  = width > height ? height : width
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            // 背景用の円（奥のレイヤー）
                            Circle()
                                .stroke(Color("MonoColor").opacity(0.1), style: StrokeStyle(lineWidth: shortSide * 0.2, lineCap: .butt, lineJoin: .miter))
                                .scaledToFit()
                            //輪郭線の開始位置を12時の方向にする(デフォルトは3時の方向)
                                .padding(shortSide * 0.2)
                            // メインの円(一番手前のレイヤー)
                            Circle()
                                .trim(from: CGFloat(self.timeManager.timerRunMode == .focus ? (1 - (self.timeManager.duration / Double(self.timeManager.maxFocusValue))) : 0),
                                      to: CGFloat(self.timeManager.timerRunMode == .focus ? 1 : 1 - (self.timeManager.duration / Double(self.timeManager.maxRestValue))))
                                .stroke(self.timeManager.timerRunMode == .focus ? self.timeManager.mainColor : self.timeManager.subColor,
                                        style: StrokeStyle(lineWidth: shortSide * 0.2,
                                                           lineCap: .butt,
                                                           lineJoin: .miter))
                                .scaledToFit()
                            //輪郭線の開始位置を12時の方向にする(デフォルトは3時の方向)
                                .rotationEffect(Angle(degrees: -90))
                                .padding(shortSide * 0.2)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            if timeManager.isTimerViewOn {
                                TimerView()
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

// GeometryReader { geometry in }
//geometry.frame(in: .global).width

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}

