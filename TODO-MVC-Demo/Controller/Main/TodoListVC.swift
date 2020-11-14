//
//  TodoListVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

protocol todoCelldelegate{
    func displayTaskDescription(description: String)
}

class TodoListVC: UIViewController {
    
    // MARK:- Properties
    var userTasksArr = [TaskData]()
    var presenter: TodoListPresenter!
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        setableView()
        UserDefaultsManager.shared().isLoggedIn = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getUserTasks()
        presenter.getUserTasks()
        self.tableView.reloadDataWithoutScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getUserTasks()
        presenter.getUserTasks()
        self.tableView.reloadDataWithoutScroll()
    }
    
    // MARK:- Public Methods
    class func create() -> TodoListVC {
        let todoListVC: TodoListVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.todoListVC)
        todoListVC.presenter = TodoListPresenter(view: todoListVC.self)
        return todoListVC
    }
    
    
}

// MARK:- Tableview Extension
extension TodoListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.userTasksArrCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TodoCell, for: indexPath) as? TodoCell else{
            return UITableViewCell()
        }
        presenter.configure(cell: cell, for: indexPath.row)
        cell.deleteTaskBtn.tag = indexPath.row
        cell.deleteTaskBtn.addTarget(self, action: #selector(deleteTaskBtnTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func deleteTaskBtnTapped(_ sender: UIButton){
        // use the tag of button as index
        presenter.deleteTask(index: sender.tag)
    }
}

// MARK:- Extension reload Tableview Without Scroll
extension UITableView {
    
    func reloadDataWithoutScroll() {
        let offset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(offset, animated: false)
    }
}

// MARK:- Extension Private Methods
extension TodoListVC{
    private func setableView(){
        tableView.register(UINib(nibName: Cells.TodoCell, bundle: nil), forCellReuseIdentifier: Cells.TodoCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setNavbar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile" , style: .plain, target: self, action:  #selector(tapLeftBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tapRightBtn))
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 25.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @objc private func tapLeftBtn(){
        goToProfileVC()
    }
    
    @objc private func tapRightBtn(){
        addTaskBtn()
        
    }
    
    private func addTaskBtn(){
       presenter.addTask()
    }
    
    private func goToProfileVC() {
        let profileVC = ProfileVC.create()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension TodoListVC: TodoListDelegate{
    func taskAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func reloadDataWithoutScroll() {
        tableView.reloadData()
        tableView.reloadDataWithoutScroll()
    }
    
    func showAlert(alertTitle: String, message: String, actionTitle: String) {
        showAlertWithCancel(alertTitle: alertTitle, message: message, actionTitle: actionTitle)
    }
    
}

