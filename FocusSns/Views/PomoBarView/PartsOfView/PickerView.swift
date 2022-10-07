//
//  PickerView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import SwiftUI

struct PickerView: View {
    //TimeManagerのインスタンスを作成
    @EnvironmentObject var timeManager: TimeManager
    @State private var isShowingModal: Bool = false
    
    // 設定可能な時間単位の数値 (_から_までの整数のArray)
    var hours = [Int](0..<6)
    var minutes: [Int] = [0, 1, 2, 5, 10, 12, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    var seconds: [Int] = [0, 15, 30, 45]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    //ZStack{
                    VStack {
                        Spacer()
                        //時間、分、秒のPickerと単位ををHStackで横並びに
                        
                        HStack {
                            Text("集中")
                            
                            //時間単位のPicker
                            Picker(selection: self.$timeManager.hourSelection, label: Text("")) {
                                ForEach(self.hours, id: \.self) { hour in
                                    Text("\(hour)")
                                        .tag(hour)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                            .clipped()

                            Text(":")
                                .font(.headline)
                            
                            //分単位のPicker
                            Picker(selection: self.$timeManager.minSelection, label: Text("")) {
                                ForEach(self.minutes, id: \.self) { min in
                                    Text("\(min)")
                                        .tag(min)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                            
                            Text(":")
                                .font(.headline)
                            
                            //秒単位のPicker
                            Picker(selection: self.$timeManager.secSelection, label: Text("")) {
                                ForEach(self.seconds, id: \.self) { sec in
                                    Text("\(sec)")
                                        .tag(sec)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                            
                        }.padding()
                        
                        
                        HStack {
                            Text("休憩")
                            
                            //時間単位のPicker
                            Picker(selection: self.$timeManager.hourRestSelection, label: Text("")) {
                                ForEach(self.hours, id: \.self) { hour in
                                    Text("\(hour)")
                                        .tag(hour)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                            
                            Text(":")
                                .font(.headline)
                            
                            //分単位のPicker
                            Picker(selection: self.$timeManager.minRestSelection, label: Text("")) {
                                ForEach(self.minutes, id: \.self) { min in
                                    Text("\(min)")
                                        .tag(min)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                            
                            Text(":")
                                .font(.headline)
                            
                            //秒単位のPicker
                            Picker(selection: self.$timeManager.secRestSelection, label: Text("")) {
                                ForEach(self.seconds, id: \.self) { sec in
                                    Text("\(sec)")
                                        .tag(sec)
                                }
                            }
                            .frame(width: width * 0.2, height: nil)
                        }
                        .padding()
                        Spacer()
                    }

                    Spacer()
                }
                Spacer()
            }
        }
    }
}
