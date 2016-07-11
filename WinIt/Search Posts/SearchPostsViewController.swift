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
    
    lazy var postList: [Post] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
	
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseHelper.fillpostList(0, rangeMax: 20, callback: { (offerArray) in
            
            var newPostArray: [Post] = []
            for o in offerArray{
                var exist = false
                for p in self.postList{
                    if o.key == p.key{
                        exist = true
                        newPostArray.append(p)
                    }
                }
                if !exist {
                    newPostArray.append(o)
                }
            }
            self.postList = newPostArray
            
            self.tableView.reloadData()
            
        })
    }
	
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		
	}
    
}

extension SearchPostsViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //maybe It works as lazy load
        if indexPath.row >= postList.count {
		//self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
		
        //maybe It works as lazy load
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.SearchPostsTableViewCell) as! SearchPostsTableViewCell
        
        let post = postList[postList.count-indexPath.row-1]
        if post.image == nil{
            FirebaseHelper.downloadImage(post) { (productImage) in
                //            print(productImage)
                //            cell.imageViewProduct.image = productImage
                post.image = productImage
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
		cell.populate(post)
		
        return cell
    }
}



