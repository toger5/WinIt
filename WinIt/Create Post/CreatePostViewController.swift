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
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch{
            print("error by sign out")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - IBActions
    @IBAction func imageUploadButtonTapped(sender: AnyObject){
        photoTaker = ImageHelper(viewController: self) { (image) in
            self.imageView.image = image
            self.postImage = image
        }
    }
    @IBAction func postUploadButtonPressed(sender: AnyObject) {
        let name = nameTextField.text ?? "noName"
        let description = descriptionTextField.text ?? "noDescription"
        let time = Double(seconds + (mins + (hours + days*24)*60)*60)
        let user = FIRAuth.auth()!.currentUser
        if user == nil {
            print("user is nil")
            return
        }
        
        FirebaseHelper.addPost(Post(name: name, image: postImage, description: description, eventWaitTime: time, user: user!.uid)) { (storageObj) in
            
            
            self.performSegueWithIdentifier("unwindAfterUpload", sender: self)
        }
    }
    
}
