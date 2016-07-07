//
//  MainTableViewCell.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell{
	
	var post: Post?
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var imageViewProduct: UIImageView!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var likeSwitch: UISwitch!
	
	func populate(post: Post) {
		
		self.post = post
		nameLabel.text = post.name
		descriptionLabel.text = post.description
		if let pic = post.picture{
			imageViewProduct.image = pic
		}else{
			imageViewProduct.image = UIImage(named: "NoImage")
		}
		
		likeSwitch.on = post.liked
	}
	
	@IBAction func likeTriggered(sender: AnyObject) {
		
		post?.liked = !(post?.liked)!
		print("post liked")
	}
}
