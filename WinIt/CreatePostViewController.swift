//
//  CreatePostViewController.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    var photoTaker: ImageHelper?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func imageUploadButtonTapped(sender: AnyObject){
        photoTaker = ImageHelper(viewController: self) { (image) in
            self.imageView.image = image
        }
    }
    
    @IBAction func postUploadButtonPressed(sender: AnyObject) {
        FirebaseHelper.addPost(Post(name: nameTextField.text!, picture: imageView.image, description: descriptionTextField.text, eventTime: 60*60*24*5, user: String(getuid())))
        performSegueWithIdentifier("toMainViewSegue", sender: sender)
    }
    
}
