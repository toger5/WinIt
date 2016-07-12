//
//  FieldValidator.swift
//  WinIt
//
//  Created by Steven on 7/12/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

struct FieldValidator {
    
    /// Checks for existence of empty text field
    static func emptyFieldExists(textFields: UITextField...) -> Bool {
        for field in textFields {
            if field.text!.isEmpty {
                return true
            }
        }
        return false
    }
}