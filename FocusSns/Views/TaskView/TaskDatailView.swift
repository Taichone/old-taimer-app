//
//  TaskDatailView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//
// TaskTabViewのナビゲーションリンクから呼び出される、タスクの詳細を編集できるView
//
//import SwiftUI
//
//struct TaskDetailView: View {
//    @EnvironmentObject var userInformation: UserInformation
//    var index: Int
//    var body: some View {
//        VStack {
//            //            Text("Swift実践入門")
//            //                .font(.title)
//            //                .padding(.top)
//
//            Spacer()
//            //            Text("Notes: 12章を完了させる")
//            Text(userInformation.taskList[index].notes)
//            Spacer()
//            Text(userInformation.taskList[index].notes) // 今だけ
//            Spacer()
//
//            //            Text(userInformation.taskList[index].title)
//        }.navigationTitle(Text(userInformation.taskList[index].title))
//    }
//}
//
//struct TaskDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        // プレビュー用に、0を初期値として渡しておく
//        TaskDetailView(index: 0)
//    }
//}
