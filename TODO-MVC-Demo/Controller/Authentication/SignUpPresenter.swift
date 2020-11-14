//
//  SignUpPresenter.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/13/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpDelegate: class{
    func showAlert(alertTitle: String,message: String,actionTitle: String)
    func successfullySignedUp()
    
}

class SignUpPresenter{
    
    private weak var delegate: SignUpDelegate!
    
    init(view: SignUpDelegate){
        self.delegate = view
    }
    
    
    private func isDataEntered( name: String, userEmail: String, Password: String, age: String)-> Bool{
        guard name != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter Name",actionTitle: "Dismiss")
            return false
        }
        guard userEmail != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter email",actionTitle: "Dismiss")
            return false
        }
        guard Password != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter Password",actionTitle: "Dismiss")
            return false
        }
        guard age != "" else{
            delegate.showAlert(alertTitle: "Incompleted Data Entry",message: "Please Enter Age",actionTitle: "Dismiss")
            return false
        }
        
        return true
    }
    
    private func isValidRegex(userEmail: String, password: String) -> Bool{
        guard RegexValidationManager.isValidEmail(email: userEmail) else{
            delegate.showAlert(alertTitle: "Wrong Email Form",message: "Please Enter Valid email(a@a.com)",actionTitle: "Dismiss")
            return false
        }
        guard RegexValidationManager.isValidPassword(testStr: password) else{
            delegate.showAlert(alertTitle: "Wrong Password Form",message: "Password need to be : \n at least one uppercase \n at least one digit \n at leat one lowercase \n characters total",actionTitle: "Dismiss")
            return false
        }
        return true
    }
    
    private func signUpWithEnteredData(name: String, userEmail: String, password: String, age: String, viewController: UIViewController){
        
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        let body = UserRegister(name: name, email: userEmail, password: password, age: Int(age)!)
        APIManager.registerAPIRouter(body: body){ response in
            switch response{
            case .failure(let error):
                if error.localizedDescription == "The data couldn’t be read because it isn’t in the correct format." {
                    self.delegate.showAlert(alertTitle: "Error",message: "Incorrect Email and Password",actionTitle: "Dismiss")
                }else{
                    self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
                    print(error.localizedDescription)
                }
            case .success(let result):
                print(result)
                print("Sign Up Completed")
            }
            
            self.delegate.successfullySignedUp()
            viewPresenter.hideLoading()
        }
    }
    
    func signUpUser(name: String, email: String, password: String, age: String, viewController: UIViewController){
        if isDataEntered(name: name, userEmail: email, Password: password, age: age){
            if isValidRegex(userEmail: email, password: password){
                signUpWithEnteredData(name: name, userEmail: email, password: password, age: age,viewController: viewController)
                
            }
        }
    }
    
    
}
