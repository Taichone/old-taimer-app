//
//  TableClockView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

struct ClockHands: View {
    @State var handColor: UIColor?
    @State var magWidth: CGFloat
    @EnvironmentObject var timeManager: TimeManager
    
    init(color: UIColor? = nil, magWidth: CGFloat) {
        if let color = color {
            self.handColor = color
        } else {
            self.handColor = nil
        }
        self.magWidth = magWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            let shortSide = geometry.size.height > geometry.size.width ? geometry.size.width : geometry.size.height
            let addLineX = shortSide * magWidth
            let addLineY = shortSide * 0.05
            // Path は多角形を作る。 .move(始点とする座標) .addLine(頂点)
            Path { path in
                path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                path.addLine(to:CGPoint(x: geometry.size.width / 2 - addLineX, y: geometry.size.height / 2 - addLineY))
                path.addLine(to:CGPoint(x: geometry.size.width / 2 - addLineX, y: geometry.size.height / 2 - shortSide / 2 + addLineY))
                path.addLine(to:CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2 - shortSide / 2))
                path.addLine(to:CGPoint(x: geometry.size.width / 2 + addLineX, y: geometry.size.height / 2 - shortSide / 2 + addLineY))
                path.addLine(to:CGPoint(x: geometry.size.width / 2 + addLineX, y: geometry.size.height / 2 - shortSide * 0.05))
            }
            .fill(Color((self.handColor == nil ? UIColor(self.timeManager.mainColor) : self.handColor ?? UIColor(Color("MonoColor")))))
        }
    }
}

struct TableClockView: View {
    @EnvironmentObject var clockManager: ClockManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 時針
                ClockHands(magWidth: 0.03)
                    .scaleEffect(0.6)
                    .rotationEffect(.degrees(Double(self.clockManager.currentHour) * 30.0 + Double(self.clockManager.currentMinute) * 0.5), anchor: UnitPoint(x: 0.5, y: 0.5))
                
                // 分針
                ClockHands(magWidth:0.015)
                    .scaleEffect(0.9)
                    .rotationEffect(
                        .degrees(Double(self.clockManager.currentMinute) * 6.0 + Double(self.clockManager.currentSecond) * 0.1), anchor: UnitPoint(x: 0.5, y: 0.5))
                
                // 秒針
                ClockHands(color: UIColor(Color("MonoColor")), magWidth: 0.01)
                    .scaleEffect(0.9)
                    .rotationEffect(.degrees(Double(self.clockManager.currentSecond * 6)), anchor: UnitPoint(x: 0.5, y: 0.5))
                
                DigitalClockView()
                    .scaleEffect(0.5)
                    .position(x: self.clockManager.currentMinute > 30 ? geometry.size.width * 0.8 : geometry.size.width * 0.2, y: geometry.size.height * 0.8)
            }
        }
    }
}

struct DigitalClockView: View {
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var clockManager: ClockManager
    
    var body: some View {
        GeometryReader { geometry in
            let shortSide = geometry.size.height > geometry.size.width ? geometry.size.width : geometry.size.height
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(String(format: self.clockManager.currentHour >= 10 ? "%02d:%02d" : "%01d:%02d",
                                self.clockManager.currentHour,
                                self.clockManager.currentMinute))
                        .font(.system(size: shortSide * 0.15, weight: .bold, design: .default))
                        .foregroundColor(self.timeManager.mainColor)
                        .shadow(radius: 6)
                        .lineLimit(1)
                        .padding(shortSide * 0.05)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}


struct TableClockView_Previews: PreviewProvider {
    static var previews: some View {
        TableClockView()
            .preferredColorScheme(.dark)
            .environmentObject(ClockManager())
            .previewLayout(.sizeThatFits)
    }
}
