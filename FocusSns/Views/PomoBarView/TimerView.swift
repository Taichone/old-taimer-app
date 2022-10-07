//
//  TimerView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let shortSide  = width > height ? height : width
            let color = self.timeManager.timerRunMode == .focus ? self.timeManager.mainColor : self.timeManager.subColor
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if self.timeManager.displayedTimeFormat == .hr {
                        Text(self.timeManager.displayTimer())
                            .font(.system(size: shortSide * 0.08, weight: .bold, design: .default))
                            .foregroundColor(color)
                            .lineLimit(1)
                            .padding()
                    } else if self.timeManager.displayedTimeFormat == .min {
                        Text(self.timeManager.displayTimer())
                            .font(.system(size: shortSide * 0.1, weight: .bold, design: .default))
                            .foregroundColor(color)
                            .lineLimit(1)
                            .padding()
                    } else {
                        Text(self.timeManager.displayTimer())
                        //文字サイズ大
                            .font(.system(size: shortSide * 0.2, weight: .bold, design: .default))
                            .foregroundColor(color)
                            .lineLimit(1)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}
