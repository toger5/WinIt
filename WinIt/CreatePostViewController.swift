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
	
	var secs = 0, mins = 1, hours = 0, days = 0
    var photoTaker: ImageHelper?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
	
	var postImage: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func imageUploadButtonTapped(sender: AnyObject){
        photoTaker = ImageHelper(viewController: self) { (image) in
            self.imageView.image = image
			self.postImage=image
        }
    }
    
    @IBAction func postUploadButtonPressed(sender: AnyObject) {
        let n = nameTextField.text ?? "noName"
        let d = descriptionTextField.text ?? "noDescription"
		let time = Double(secs + (mins + (hours + days*24)*60)*60)
        FirebaseHelper.addPost(Post(name: n, picture: postImage, description: d, eventTime: time, user: String(FIRAuth.auth()!.currentUser!.uid)))
//        performSegueWithIdentifier("toMainViewSegue", sender: sender)
    }
    
}
