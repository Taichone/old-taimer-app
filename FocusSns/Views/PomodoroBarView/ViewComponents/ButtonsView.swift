//
//  ButtonsView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI


struct ButtonsView: View {
    @EnvironmentObject var timeManager: TimeManager
    var body: some View {
        HStack {
            Image(systemName: "stop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .opacity(self.timeManager.timerStatus == .stopped ? 0.1 : 1)
                .onTapGesture {
                    if timeManager.timerStatus != .stopped {
                        self.timeManager.impactLight.impactOccurred()
                        self.timeManager.reset()
                    }
                }
            Spacer()
            Image(systemName: self.timeManager.timerStatus == .running ? "pause.fill" : "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .opacity(self.timeManager.hourSelection == 0 && self.timeManager.minSelection == 0 && self.timeManager.secSelection == 0 ? 0.1 : 1)
                .onTapGesture {
                    self.timeManager.impactLight.impactOccurred()
                    
                    //最初は集中時間から始まるように
                    if timeManager.timerStatus == .stopped {
                        self.timeManager.timerRunMode = .focus
                        self.timeManager.setTimer()
                    }
                    
                    if (timeManager.duration != 0) && timeManager.timerStatus != .running {
                        self.timeManager.start()
                    } else if timeManager.timerStatus == .running {
                        self.timeManager.pause()
                    }
                }
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}