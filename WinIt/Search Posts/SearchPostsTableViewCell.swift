//
//  MainTableViewCell.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class SearchPostsTableViewCell: UITableViewCell{
	
    // MARK: - Properties
	var post: Post?
	
    // MARK: - IBOutlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var imageViewProduct: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var likeSwitch: UISwitch!
	
    // MARK: - IBActions
	@IBAction func likeTriggered(sender: AnyObject) {
		post?.setLiked(likeSwitch.on)
	}
    
    // MARK: - Helper Methods
    func populate(post: Post) {
        
        self.post = post
        post.cell = self
        nameLabel.text = post.name
        descriptionLabel.text = post.description
        
        if let image = post.image {
            imageViewProduct.image = image
        } else {
            imageViewProduct.image = UIImage(named: "NoImage")
        }
        
        updateLiked()
    }
    
    func updateLiked() {
        likeSwitch.on = post?.liked ?? false
    }
}
