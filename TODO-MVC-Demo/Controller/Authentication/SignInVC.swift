//
//  SignInVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/28/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    // MARK:- Properties
    var presenter: SignInPresenter!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceHolders()
        UserDefaultsManager.shared().isLoggedIn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        signInVC.presenter = SignInPresenter(view: signInVC.self)
        return signInVC
    }
    
    // MARK:- Actions
    @IBAction func signInSubmittBtn(_ sender: UIButton) {
        presenter.logInUser(email: userEmailTextField.text!, password: userPasswordTextField.text!,viewController: self)
        
    }
    
    @IBAction func signUpAccountBtnTapped(_ sender: UIButton) {
        goToSignUpVC()
    }
}

// MARK:- Extension Private Methods
extension SignInVC{
    private func setPlaceHolders(){
        userEmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        userPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    private func goToTodoListVC(){
        let todoListVC = TodoListVC.create()
        navigationController?.pushViewController(todoListVC, animated: true)
    }
    
    
    private func goToSignUpVC() {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

// MARK:- extension delegate Presenter
extension SignInVC: SignInDelegate{
    
    func showAlert(alertTitle: String, message: String, actionTitle: String) {
        showAlertWithCancel(alertTitle: alertTitle, message: message, actionTitle: actionTitle)
    }
    
    func successfullyLoggedIn() {
        goToTodoListVC()
    }
}
