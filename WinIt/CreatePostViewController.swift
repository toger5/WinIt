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
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func uploadButtonTapped(sender: AnyObject){
        photoTaker = ImageHelper(viewController: self) { (image) in
            self.imageView.image = image
        }
    }
    
}
