//
//  MainTableViewCell.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var likeSwitch: UISwitch!
	
	@IBAction func likeTriggered(sender: AnyObject) {
		
		print("post liked")
	}
}
