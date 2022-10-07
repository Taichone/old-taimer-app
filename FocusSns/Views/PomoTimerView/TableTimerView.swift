//
//  TableTimerView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//
//.onAppear(perform: { UIApplication.shared.isIdleTimerDisabled = true })
//.onDisappear(perform: { UIApplication.shared.isIdleTimerDisabled = false })
//

import SwiftUI

struct TableTimerView: View {
    @EnvironmentObject var timeManager: TimeManager
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(self.timeManager.displayTimer())
                        .font(.system(size: width * 0.15, weight: .bold, design: .default))
                        .foregroundColor(self.timeManager.mainColor)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .lineLimit(1)
                        .padding(width * 0.05)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
