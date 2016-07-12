//
//  SearchPostsViewController.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchPostsViewController: UIViewController {
    
    // MARK: - Properties
    let currentUser = FIRAuth.auth()!.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    var postList: [Post] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycles
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseHelper.downloadPosts(0, rangeMax: 20, callback: { (offers) in
            
            var newPosts: [Post] = []
            
            for i in offers {
                var doesExist = false
                for p in self.postList {
                    if i.key == p.key {
                        doesExist = true
                        newPosts.append(p)
                    }
                }
                if !doesExist {
                    newPosts.append(i)
                }
            }
            self.postList = newPosts
            self.tableView.reloadData()
        })
    }
	
    // MARK: - Segues
    @IBAction func cancelCreatePost(segue: UIStoryboardSegue) {
        
    }
    
	@IBAction func unwindAfterUpload(segue: UIStoryboardSegue) {
		
	}
    
}

// MARK: - Table View Data Source
extension SearchPostsViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //maybe It works as lazy load
        if indexPath.row >= postList.count - 2 {
		//self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
		
        //maybe It works as lazy load
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.SearchPostsTableViewCell) as! SearchPostsTableViewCell
        
        let post = postList[postList.count-indexPath.row-1]
        
        if post.image == nil {
            FirebaseHelper.downloadImage(post) { (productImage) in
                post.image = productImage
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
		cell.populate(post)
		
        return cell
    }
}



