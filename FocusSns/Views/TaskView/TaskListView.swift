//
//  TaskListView.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//
//
//import SwiftUI
//import Combine
//import Foundation
//
// // self.presentAddNewItem.toggle() // (4)
//
//struct TaskListView: View {
//    @ObservedObject var taskListVM = TaskListViewModel() // (7)
//    @State var presentAddNewItem = false
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                List {
//                    ForEach (taskListVM.taskCellViewModels) { taskCellVM in // (8)
//                        TaskCell(taskCellVM: taskCellVM) // (1)
//                    }
//                    .onDelete { indexSet in
//                        self.taskListVM.removeTasks(atOffsets: indexSet)
//                    }
//                    if presentAddNewItem { // (5)
//                        TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in // (2)
//                            if case .success(let task) = result {
//                                self.taskListVM.addTask(task: task) // (3)
//                            }
//                            self.presentAddNewItem.toggle()
//                        }
//                    }
//                }
//
//                Button(action: { self.presentAddNewItem.toggle() }) { // (6)
//                    HStack {
//                        Image(systemName: "plus.circle.fill")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                        Text("New Task")
//                    }
//                }
//                .padding()
//                .accentColor(Color(UIColor.systemRed))
//            }
//            .navigationBarTitle("Tasks")
//        }
//    }
//}
//
//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListView()
//    }
//}
//
//struct TaskCell: View {
//    @ObservedObject var taskCellVM: TaskCellViewModel // (1)
//    var onCommit: (Result<Task, InputError>) -> Void = { _ in } // (5)
//
//    var body: some View {
//        HStack {
//            Image(systemName: taskCellVM.completionStateIconName) // (2)
//                .resizable()
//                .frame(width: 20, height: 20)
//                .onTapGesture {
//                    self.taskCellVM.task.completed.toggle()
//                }
//            TextField("Enter task title", text: $taskCellVM.task.title, // (3)
//                      onCommit: { //(4)
//                if !self.taskCellVM.task.title.isEmpty {
//                    self.onCommit(.success(self.taskCellVM.task))
//                }
//                else {
//                    self.onCommit(.failure(.empty))
//                }
//            }).id(taskCellVM.id)
//        }
//    }
//}
//
//enum InputError: Error {
//    case empty
//}
//
//// タスクセルビューのモデル (機能)
//class TaskCellViewModel: ObservableObject, Identifiable  { // (6)
//    @Published var task: Task
//
//    var id: String = ""
//    @Published var completionStateIconName = ""
//
//    private var cancellables = Set<AnyCancellable>()
//
//    static func newTask() -> TaskCellViewModel {
//        TaskCellViewModel(task: Task(title: "", notes: "", priority: .medium, completed: false))
//    }
//
//    init(task: Task) {
//        self.task = task
//
//        $task // (8)
//            .map { $0.completed ? "largecircle.fill.circle" : "circle" }
//            .assign(to: \.completionStateIconName, on: self)
//            .store(in: &cancellables)
//
//        $task // (7)
//            .map { $0.id }
//            .assign(to: \.id, on: self)
//            .store(in: &cancellables)
//
//    }
//}
//
//
//// タスクリストビューのモデル (機能)
//class TaskListViewModel: ObservableObject {
//    @Published var taskCellViewModels = [TaskCellViewModel]()
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        self.taskCellViewModels = testDataTasks.map { task in // (2)
//            TaskCellViewModel(task: task)
//        }
//    }
//
//    func removeTasks(atOffsets indexSet: IndexSet) { // (4)
//        taskCellViewModels.remove(atOffsets: indexSet)
//    }
//
//    func addTask(task: Task) { // (5)
//        taskCellViewModels.append(TaskCellViewModel(task: task))
//    }
//}
