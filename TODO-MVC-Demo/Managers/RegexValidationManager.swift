//
//  RegexValidation.swift
//  TODO-MVC-Demo
//
//  Created by yasser on 11/12/20.
//  Copyright © 2020 Yasser Aboibrahim. All rights reserved.
//

import Foundation
import UIKit

class RegexValidationManager{
    class func isValidEmail(email: String?)-> Bool{
        guard email != nil else {return false}
        let regEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let pred = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
        return pred.evaluate(with: email)
    }
    
    class func isValidPassword(testStr: String?)-> Bool{
        guard testStr != nil else {return false}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
        
    }
}
