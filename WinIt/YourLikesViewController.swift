//
//  File.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase

class YourLikesViewController: UIViewController {
    var likedPosts: [Post] = []
	
    @IBOutlet weak var tableVeiw: UITableView!
	
	override func viewDidLoad(){
        super.viewDidLoad()
		tableVeiw.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		FirebaseHelper.getLikedPosts(likesLoaded)
    }
    
    
    func likesLoaded(serverPostList: [Post]){
        var newPostArray: [Post] = []
        
        for o in serverPostList{
            var exist = false
            for p in self.likedPosts{
                if o.key == p.key{
                    exist = true
                    newPostArray.append(p)
                }
            }
            if !exist{
                newPostArray.append(o)
            }
        }
        likedPosts = newPostArray
        tableVeiw.reloadData()
    }
}

extension YourLikesViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return likedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedPostCell") as! LikedPostCell
		let post = likedPosts[likedPosts.count-indexPath.row-1]
		if post.picture == nil{
			FirebaseHelper.downloadImage(post) { (productImage) in
				//            print(productImage)
				//            cell.imageViewProduct.image = productImage
				post.picture = productImage
				tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			}
		}
		cell.populate(post)
        return cell
    }
}