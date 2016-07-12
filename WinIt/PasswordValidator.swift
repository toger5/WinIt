//
//  PasswordValidator.swift
//  WinIt
//
//  Created by Steven on 7/12/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Foundation

struct PasswordValidator {
    
    /// Checks if a password is greater than 6 characters
    static func passwordInvalidLength(password: String) -> Bool {
        return password.characters.count < 6
    }
    
    /// Checks if password contains atleast one number and one capital letter
    static func passwordTooWeak(password: String) -> Bool {
        let capitalSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let numberSet = NSCharacterSet(charactersInString: "0123456789")
        return password.rangeOfCharacterFromSet(capitalSet) == nil || password.rangeOfCharacterFromSet(numberSet) == nil
        
    }
}