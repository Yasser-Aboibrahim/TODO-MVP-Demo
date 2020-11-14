//
//  TodoListPresenter.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/13/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

protocol TodoListDelegate: class{
    func showAlert(alertTitle: String,message: String,actionTitle: String)
    func reloadDataWithoutScroll()
    func taskAlert(alert: UIAlertController)
}

class TodoListPresenter{
    
    private var userTasksArr = [TaskData]()
    private weak var delegate: TodoListDelegate!
    
    init(view: TodoListDelegate){
        self.delegate = view
    }
    
    
     func getUserTasks(){
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        
        APIManager.getUserTasksAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.delegate.showAlert(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                if let taskArr = result?.data{
                    if taskArr.isEmpty{
                        self.userTasksArr = []
                    }else{
                        self.userTasksArr = taskArr
                    }
                }
                viewPresenter.hideLoading()
                self.delegate.reloadDataWithoutScroll()
            }
            
        }
    }
    
    func userTasksArrCount() -> Int{
        return userTasksArr.count
    }
    
    func configure(cell: todoCelldelegate, for index: Int){
        let task = userTasksArr[index]
        cell.displayTaskDescription(description: task.description)
    }
    
    
    func deleteTask(index: Int){
        let task = userTasksArr[index]
        UserDefaultsManager.shared().taskId = task.id
        let deleteAlert = UIAlertController(title: "Sorry", message: "Are You Sure You Want To Delete This Task?", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            APIManager.deleteTaskAPIRouter{ (response) in
                switch response{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    print("The task is deleted ")
                    print(result)
                    
                    
                }
                DispatchQueue.main.async {
                    self.getUserTasks()
                    self.delegate.reloadDataWithoutScroll()
                }
                
                
            }
        }))
        delegate.taskAlert(alert: deleteAlert)
        
    }
    
     func addTask(){
        let viewPresenter = UIView()
        let alertController = UIAlertController(title: "Add Task", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Task"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let taskTextField = alertController.textFields![0] as UITextField
            if let taskTF = taskTextField.text{
                viewPresenter.showLoading()
                APIManager.addTaskAPIRouter(description: taskTF){ (response) in
                    switch response{
                    case .failure(let error):
                        self.delegate.showAlert(alertTitle: "Error",message: "\(error.localizedDescription)",actionTitle: "Dismiss")
                    case .success(let result):
                        print(result)
                        self.getUserTasks()
                    }
                    DispatchQueue.main.async {
                        self.delegate.reloadDataWithoutScroll()
                    }
                    viewPresenter.hideLoading()
                    
                }
            }else{
                self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.delegate.taskAlert(alert: alertController)
    }
    
}
