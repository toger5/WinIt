//
//  ViewController.swift
//  WinIt
//
//  Created by Timo on 03/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ViewController: UIViewController {
    let currentUser = FIRAuth.auth()!.currentUser
    let rootRef = FIRDatabase.database().reference()
    
    var postList: [Post] = []
    
	//let dataListOfOffers = [Offer(),Offer(name: "computer", picture:nil, description:"anAlmostBrokenComputer", shippingCostIncluded: false)]
    @IBOutlet weak var tableView: MainTableView!
	
	override func viewDidLoad() {
		//print(FIRUserInfo)
        print("curretn Logged In user: \(currentUser)")
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
	}
	
    override func viewDidAppear(animated: Bool) {
		//print(FirebaseHelper.getOfferCount())
		//rootRef.child("test0").setValue("baccccc")
        super.viewDidAppear(animated)
        FirebaseHelper.addPost(Post(name: "haus", picture: nil, description: "meinHaus", key: "", eventTime: 1000, user:  currentUser!.uid))
        FirebaseHelper.fillpostList(0,rangeMax: 20,callback: { (offerArray) in
			print("offer array: \(offerArray)")
			self.postList = offerArray
            self.tableView.reloadData()
            //print("test: \(self.postList)")
        })
    }
	
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		
	}

}

extension ViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//return dataListOfOffers.count
        print(postList.count)
        return postList.count
    }
	
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //maybe It works as lazy load
        if indexPath.row >= postList.count {
		//self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        
        
        
        //maybe It works as lazy load
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MainTableViewCell
        
        let post = postList[indexPath.row]
		
		print("post list:")
		print(postList)
		
        return populateCell(cell, post: post)
    }
    
    func populateCell(cell: MainTableViewCell, post:Post) -> MainTableViewCell{
		
        cell.nameLabel.text = post.name
        cell.descriptionLabel.text = post.description
        if let pic = post.picture{
            cell.imageViewProduct.image = pic
        }else{
            cell.imageViewProduct.image = UIImage(named: "NoImage")
        }
		
		cell.likeSwitch.on=post.liked
		
        return cell
    }
}



