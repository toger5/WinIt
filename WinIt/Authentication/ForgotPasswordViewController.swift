//
//  ForgotPasswordViewController.swift
//  iChallenge
//
//  Created by Jake on 7/2/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

import UIKit

class ForgotPasswordViewController : UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Preparations
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - IBActions
    @IBAction func sendEmailButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
