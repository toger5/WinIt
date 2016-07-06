//
//  UserRegisterViewController.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import FirebaseAuth
class UserRegisterViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!) { (user, error) in
            print(user)
        }
    }
}
