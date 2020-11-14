//
//  ProfileVC.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 10/31/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UITableViewController {

    // MARK:- Properties
    var userData: UserData?
    let imagepicker = UIImagePickerController()
    var presenter: ProfilePresenter!
    
    // MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameWithNoImage: UILabel!
    
    // MARK:- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        imagepicker.delegate = self
        presenter.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getUserImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:- Public Methods
    class func create() -> ProfileVC {
        let profileVC: ProfileVC = UIViewController.create(storyboardName: Storyboards.main, identifier: ViewControllers.profileVC)
        profileVC.presenter = ProfilePresenter(view: profileVC.self)
        return profileVC
    }
    
    
    // MARK:- Actions
    @IBAction func logOutBtn(_ sender: UIButton) {
        presenter.logOut()
    }
    
    @IBAction func updateUserDataBtnTapped(_ sender: UIButton) {
        presenter.updateUserData()
    }
}

// MARK:- Extension Image Picker
extension ProfileVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            presenter.uploadUserImage(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Extension Private Methods
extension ProfileVC{
    private func goToSignInVC() {
        let signInVC = SignInVC.create()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func setNavbar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload Photo", style: .plain, target: self, action: #selector(tapRightBtn))
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 15.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
    }
    
    @objc private func tapRightBtn(){
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
    }
}

extension ProfileVC: ProfileDelegate{
    func updateAge(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func successfullyLoggedOut() {
        goToSignInVC()
    }
    
    
    func showAlert(alertTitle: String, message: String, actionTitle: String) {
        showAlertWithCancel(alertTitle: alertTitle, message: message, actionTitle: actionTitle)
    }
    func setUserData(userData: UserData) {
        nameLabel.text = userData.name
        emailLabel.text = userData.email
        ageLabel.text = "\(userData.age)"
    }
    
    func setUserImage(image: UIImage) {
        userImageView.image = image
    }
    
    func userNameWithNoImage(nameInitials: String) {
        userNameWithNoImage.text = nameInitials
    }
    
    
}
