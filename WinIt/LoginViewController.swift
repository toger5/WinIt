//
//  LoginViewController.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController{
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func registerSeguePressed(sender: AnyObject) {
        performSegueWithIdentifier("registerSegue", sender: sender)

    }


    @IBAction func logInButtonPressed(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!) { (user, error) in
            print(error)
            if user != nil{
                self.performSegueWithIdentifier("logInSegue", sender: sender)
            }
        }

        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var loginSuccess = false
//        if segue.identifier == "logInSegue"{
//            FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!) { (user, error) in
//                print(error)
//                if user != nil{
//                    loginSuccess = true
//                }
//            }
//        }
//    }
    
}
