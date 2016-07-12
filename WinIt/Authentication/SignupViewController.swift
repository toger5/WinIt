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
        
        switch true {
        case FieldValidator.emptyFieldExists(usernameTextField, passwordTextField, emailTextField):
            ErrorAlertService.displayAlertFor(.EmptyField, withPresenter: self)
            
        case EmailValidator.invalidEmail(email):
            ErrorAlertService.displayAlertFor(.InvalidEmail, withPresenter: self)
            
        case PasswordValidator.passwordInvalidLength(password):
            ErrorAlertService.displayAlertFor(.PasswordLength, withPresenter: self)
            
        case PasswordValidator.passwordTooWeak(password):
            ErrorAlertService.displayAlertFor(.InvalidPassword, withPresenter: self)
            
        case UsernameValidator.usernameInvalidLength(username):
            ErrorAlertService.displayAlertFor(.UsernameLength, withPresenter: self)
            
        case UsernameValidator.invalidCharactersIn(username):
            ErrorAlertService.displayAlertFor(.InvalidUsername, withPresenter: self)
            
        default:
            self.signUpUserWith(email, username: username, password: password)
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
    
    func signUpUserWith(email: String, username: String, password: String) {
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
    
    func loginFailed() {
        let animation = CustomAnimation(view: signUpButton, delay: 0, direction: .Left, repetitions: 4, maxRotation: 0, maxPosition: 40, duration: 0.06)
        animation.shakeAnimation()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        let password = passwordTextField.text ?? ""
        
        switch true {
        case PasswordValidator.passwordInvalidLength(password):
            passwordLabel.textColor = .redColor()
            passwordLabel.text = passwordTooShort
        case PasswordValidator.passwordTooWeak(password):
            passwordLabel.textColor = .redColor()
            passwordLabel.text = "Password too weak"
        default:
            passwordLabel.textColor = .greenColor()
            passwordLabel.text = passwordGood
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

