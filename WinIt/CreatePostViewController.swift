//
//  CreatePostViewController.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import FirebaseAuth
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
        let n = nameTextField.text ?? "keinNameEingegeben"
        let d = descriptionTextField.text ?? "keineDescriptionEingegeben"
        FirebaseHelper.addPost(Post(name: n, picture: imageView.image, description: d, eventTime: 60*60*24*5, user: String(FIRAuth.auth()!.currentUser!.uid)))
//        performSegueWithIdentifier("toMainViewSegue", sender: sender)
    }
    
}
