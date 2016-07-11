//
//  SignupViewController.swift
//  iChallenge
//
//  Created by Jake on 7/2/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController : UIViewController {
    
    // MARK: - Properties
    let passwordGood = "Your password is valid"
    let passwordTooShort = "Your password is too short. Please type atleast 6 characters"
    
    // MARK: - IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField:    UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Preparations
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - IBActions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        checkAndSignOutCurrentUser()
        
        let username = usernameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        guard username.characters.count > 0 && password.characters.count > 5 && email.containsString("@") else { return }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                
                changeRequest.displayName = username
                
                changeRequest.commitChangesWithCompletion() { error in
                    
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    FirebaseHelper.createAccount(username, coins: 0)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("Login", object: nil)
                }
            }
            
        }
    }
    
    // MARK: - Helper Methods
    func checkAndSignOutCurrentUser() {
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
            } catch {
                print("error")
            }
            
        }
    }
    
    func loginFailed() {
        let animation = CustomAnimation(view: signUpButton, delay: 0, direction: .Left, repetitions: 4, maxRotation: 0, maxPosition: 40, duration: 0.06)
        animation.shakeAnimation()
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        let password = passwordTextField.text ?? ""
        
        if password.characters.count > 5 {
            passwordLabel.text = passwordGood
            passwordLabel.textColor = .greenColor()
            
        } else {
            passwordLabel.text = passwordTooShort
            passwordLabel.textColor = .redColor()
        }
    }
}

