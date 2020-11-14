//
//  SignInPresenter.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/11/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

protocol SignInDelegate: class{
    func showAlert(alertTitle: String,message: String,actionTitle: String)
    func successfullyLoggedIn()
    
}

class SignInPresenter{
    
    private weak var delegate: SignInDelegate!
    
    init(view: SignInDelegate){
        self.delegate = view
    }
    
    
    private func isDataEntered(userEmail: String, Password: String)-> Bool{
        guard userEmail != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter Email",actionTitle: "Dismiss")
            return false
        }
        guard Password != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }

        return true
    }

    private func isValidRegex(userEmail: String, Password: String) -> Bool{
        guard RegexValidationManager.isValidEmail(email: userEmail) else{
            delegate.showAlert(alertTitle: "Alert",message: "Please Enter Valid Email",actionTitle: "Dismiss")
            return false
        }
        guard RegexValidationManager.isValidPassword(testStr: Password) else{
            delegate.showAlert(alertTitle: "Alert",message: "Password is Incorect",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
     private func signInWithEnteredData(email: String, password: String, viewController: UIViewController){
  
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        
        APIManager.loginAPIRouter(email: email, password: password){ response in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.delegate.showAlert(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                print(result.token)
                UserDefaultsManager.shared().token = result.token
                UserDefaultsManager.shared().userId = result.user.id
                self.delegate.successfullyLoggedIn()
            }
            viewPresenter.hideLoading()
        }
    }
    
    func logInUser(email: String, password: String, viewController: UIViewController){
        if isDataEntered(userEmail: email, Password: password){
            if isValidRegex(userEmail: email, Password: password){
                signInWithEnteredData(email: email, password: password,viewController: viewController)
                
            }
        }
    }
    
    
}
