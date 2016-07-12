//
//  AlertService.swift
//  WinIt
//
//  Created by Steven on 7/12/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

struct ErrorAlertService {

    // MARK: - Error Messages
    
    enum ErrorMessage: String {
        case EmptyField = "Please fill out all fields"
        case InvalidEmail = "Please enter a valid email"
        case InvalidUsername = "Usernames can only contain letters, numbers, and underscores"
        case UsernameLength = "Usernames must be between 4 and 15 characters"
        case InvalidPassword = "Passwords must contain atleast one number and one capital letter"
        case PasswordLength = "Passwords must be atleast 6 characters long"
    }
    
    static func displayAlertFor(error: ErrorMessage, withPresenter presenter: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presenter.presentViewController(alertController, animated: true, completion: nil)
    }
}