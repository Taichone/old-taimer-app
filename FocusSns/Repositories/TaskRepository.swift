//
//  TaskRepository.swift
//  FocusSns
//
//  Created by Rita on 2021/12/11.
//

import Foundation

// タスクを扱うリポジトリーのクラス全般の親
class BaseTaskRepository {
    @Published var tasks = [Task]()
}

// タスクを追加、削除、更新するためのメソッドを定義
protocol TaskRepository: BaseTaskRepository {
    func addTask(_ task: Task)
    func removeTask(_ task: Task)
    func updateTask(_ task: Task)
}

class TestDataTaskRepository: BaseTaskRepository, TaskRepository, ObservableObject {
    override init() {
        super.init()
        self.tasks = testDataTasks
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
    
    func updateTask(_ task: Task) {
        if let index = self.tasks.firstIndex(where: { $0.id == task.id } ) {
            self.tasks[index] = task
        }
    }
}
