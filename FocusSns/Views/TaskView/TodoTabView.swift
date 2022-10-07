//
//  TodoTabView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//
//
//import SwiftUI
//
//struct TaskTabView: View {
//    // App全体で同じインスタンスを共有するよ
//    @EnvironmentObject var userInformation: UserInformation
//
//    var body: some View {
//        NavigationView {
//            List {
//                Section(header: Text("MyList"), footer: Text("Your to do list")) {
//                    ForEach(0 ..< self.userInformation.toDoList.count) { idx in
//                        NavigationLink(destination: TaskDetailView(index: idx)) {
//                            Text(self.userInformation.toDoList[idx].title)
//                        }.navigationTitle(Text("list"))
//                    }
//                }
//            }.listStyle(GroupedListStyle()) // イケてるリストスタイルに設定
//        }
//    }
//}
//
//struct TodoTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskTabView()
//    }
//}

