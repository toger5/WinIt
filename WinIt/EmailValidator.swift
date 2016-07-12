//
//  EmailValidator.swift
//  WinIt
//
//  Created by Steven on 7/12/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Foundation

struct EmailValidator {
    
    /// Checks if email is invalid: Pattern [characters]@[characters].[characters]
    static func invalidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return !test.evaluateWithObject(email)
    }
}