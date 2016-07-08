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
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        print(FIRAuth.auth()?.currentUser)
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
            } catch {
                print("error")
            }
            
        }
            print("whats up")
            if checkLoginData(){
                FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!) { (user, error) in
                    print(error)
                    print(user)
                    
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        
                        changeRequest.displayName = self.username.text!
                        
                        changeRequest.commitChangesWithCompletion() { error in
                            if error != nil {
                                // An error happened.
                            } else {
                                //it worked
                                print("account succesfully created")
                                FirebaseHelper.createAccount(self.username.text!, coins: 0)
                                self.performSegueWithIdentifier("toApplicationSegue", sender: sender)
                            }
                        }
                        
                        
                    }else{
                        self.loginFailed()
                    }
                }
                
            }else{
                self.loginFailed()
            }
 
    }
    
    @IBAction func cancelAccountCreation(segue:UIStoryboardSegue) {
        print("wentBackToAccountCreation")
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
    
    func checkLoginData() -> Bool{
        let pas = password.text ?? ""
        let name = username.text ?? ""
        return (name.characters.count > 0 && pas.characters.count > 5)
    }
    func loginFailed(){
        let anim = CustomAnimation(obj: registerButton, repetutionAmount: 4, maxRotation: 0, maxPosition: 40, duration: 0.06)
        anim.shake()
    }
}
