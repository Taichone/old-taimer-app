//
//  ClockManager.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

class ClockManager: ObservableObject {
    // 現在時刻を格納する変数
    @Published var currentHour = Calendar.current.component(.hour, from: Date())
    @Published var currentMinute = Calendar.current.component(.minute, from: Date())
    @Published var currentSecond = Calendar.current.component(.second, from: Date())
    
    var refreshCycle: Double = 0.25
    var timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
}

