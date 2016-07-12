//
//  ArchivedViewController.swift
//  WinIt
//
//  Created by Timo on 11/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit

class ArchivedViewController: UIViewController{
    
    // MARK: - Properties
    let post: ArchivedPost? = nil //will be set by the previous viwcontroller inside the segue
    
    // MARK: - IBOutlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var winnerNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var winnerImageView: UIImageView!
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        productImageView.image = post?.image
        productNameLabel.text = post?.name
//        winnerImageView = winner
//        winnerNameLabel.text = post?.winner.0
//        winnerPoints.text = post?.participatedUsers[post?.winner].1
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
}
