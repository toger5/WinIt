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
    @IBOutlet weak var passwordAcceptanceLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var email: UITextField!
    
    let passwordOkay = "Your password is valid"
    let passwordToShort = "Your password is to short, at least 6 characters"
    var user = FIRUser?()
    @IBAction func registerButtonPressed(sender: AnyObject) {
        if user == nil{
            FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!) { (user, error) in
                print(error)
                print(user)
                self.user = user
                if error == nil{
                    print("account succesfully created")
                    self.performSegueWithIdentifier("toApplicationSegue", sender: sender)
                }else{
                     self.loginFailed()
                }
            }
        }
    }
    @IBAction func passwordEditingUpdated(sender: AnyObject) {
        let pas = password.text ?? ""
        if pas.characters.count > 5{
            passwordAcceptanceLabel.text = passwordOkay
            passwordAcceptanceLabel.textColor = .greenColor()
            
        }else{
            passwordAcceptanceLabel.text = passwordToShort
            passwordAcceptanceLabel.textColor = .redColor()
        }
    }
    
    func loginFailed(){
        let anim = CustomAnimation(obj: registerButton, repetutionAmount: 4, maxRotation: 0, maxPosition: 40, duration: 0.06)
        anim.shake()
    }
}
