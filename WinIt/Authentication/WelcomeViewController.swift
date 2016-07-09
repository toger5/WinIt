//
//  WelcomeViewController.swift
//  iChallenge
//
//  Created by Jake on 7/2/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController : UIViewController {
    
    // MARK:- Properties
    let titleLabel: UILabel = UILabel()
    var buttonShake: CustomAnimation!
    
    // MARK:- Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }
    
    // MARK:- Preparations
    func prepareNavigationBar() {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK:- Actions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("Login", object: nil)
            
        }
    }
}


