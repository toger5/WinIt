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
    
    // MARK: - Properties
    var seconds = 0
    var mins = 1
    var hours = 0
    var days = 0
    var photoTaker: ImageHelper?
    var postImage: UIImage?
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var uploadPostButton: UIButton!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions
    @IBAction func imageUploadButtonTapped(sender: AnyObject){
        photoTaker = ImageHelper(viewController: self) { (image) in
            self.imageView.image = image
            self.postImage = image
        }
    }
    @IBAction func postUploadButtonPressed(sender: AnyObject) {
        uploadPostButton.enabled = false
        let name = nameTextField.text ?? "No name"
        let description = descriptionTextField.text ?? "No description"
        let time = Double(seconds + (mins + (hours + days*24)*60)*60)
        let user = FIRAuth.auth()!.currentUser
        
        if user == nil {
            print("user is nil")
            return
        }
        
        FirebaseHelper.uploadPost(Post(name: name, image: postImage, description: description, eventWaitTime: time, user: user!.uid)) { (storageObj) in
            
            
            self.performSegueWithIdentifier(SegueIdentifiers.UnwindAfterUpload, sender: self)
        }
    }
    
}
