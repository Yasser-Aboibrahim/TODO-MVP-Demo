//
//  ProfilePresnter.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/13/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileDelegate: class{
    func showAlert(alertTitle: String,message: String,actionTitle: String)
    func successfullyLoggedOut()
    func setUserData(userData: UserData)
    func setUserImage(image: UIImage)
    func userNameWithNoImage(nameInitials: String)
    func updateAge(alert: UIAlertController)
}

class ProfilePresenter{
    
    private var userData: UserData?
    private weak var delegate: ProfileDelegate!
    
    init(view: ProfileDelegate){
        self.delegate = view
    }
    
    
     func getUserData(){
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        
        APIManager.getUserDataAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                self.userData = result
                
                print(result)
                self.setUserData()
            }
            DispatchQueue.main.async {
                self.getUserImage()
                self.userNameInitials()
                viewPresenter.hideLoading()
            }
            
        }
    }
    
     func getUserImage(){
        let viewPresenter = UIView()
        viewPresenter.showLoading()

        APIManager.getingUserImageAPIRouter { (image, error) in
            guard  error == nil else{
                print(error!.localizedDescription)
                return
            }
            guard  image != nil else{
                print("No Image")
                return
            }
            self.delegate.setUserImage(image: image!)
            viewPresenter.hideLoading()
        }
    }
    
    private func setUserData(){
            delegate.setUserData(userData: userData!)
    }
    
    private func userNameInitials(){
        if let stringInput = userData?.name {
            let initials = stringInput.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            delegate.userNameWithNoImage(nameInitials: initials)
        }else{
            delegate.userNameWithNoImage(nameInitials: "")
        }
    }
    
     func logOut(){
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        APIManager.logOutUserAPIRouter{ (response) in
            switch response{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                print(result)
                print("Log Out Completed")
            }
            DispatchQueue.main.async {
                viewPresenter.hideLoading()
                UserDefaultsManager.shared().token?.removeAll()
                self.delegate.successfullyLoggedOut()
            }
        }
    }
    
     func uploadUserImage(image: UIImage){
        let viewPresenter = UIView()
        viewPresenter.showLoading()
        APIManager.uploadUserImage(userImage: image){ error in
            if error != nil {
                self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
            } else {
                print("Uploading photo is Completed")
            }
            DispatchQueue.main.async {
                self.getUserImage()
                viewPresenter.hideLoading()
            }
            
        }
    }
    func updateUserData(){
        let viewPresenter = UIView()
    let alertController = UIAlertController(title: "Update Age", message: "", preferredStyle: UIAlertController.Style.alert)
    alertController.addTextField { (textField : UITextField!) -> Void in
    textField.placeholder = "New Age"
    }
    let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
        let taskTextField = alertController.textFields![0] as UITextField
        if let taskTF = Int(taskTextField.text ?? ""){
            viewPresenter.showLoading()
            APIManager.updateUserDataAPIRouter(age: taskTF){ response in
                switch response{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    print(result)
                    
                }
                DispatchQueue.main.async {
                    self.getUserData()
                    viewPresenter.hideLoading()
                }
            }
        }else{
            self.delegate.showAlert(alertTitle: "Error",message: "Please try again",actionTitle: "Dismiss")
        }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
    
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    delegate.updateAge(alert: alertController)
    }
    
}
