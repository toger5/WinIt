//
//  GameViewController.swift
//  WinIt
//
//  Created by Timo on 07/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GameViewController: UIViewController{
	
	@IBOutlet weak var livePointUpdate: UILabel!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var name5: UILabel!
    
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    
    let postID: String = "-KMAUfWSciJE_jnyOPhG"
    var points = 0
    var pathToGame: FIRDatabaseReference? = nil
    var labelArray = []
    var nameArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelArray = [p1,p2,p3,p4,p5]
        nameArray = [name1,name2,name3,name4,name5]

        pathToGame = FirebaseHelper.rootRef.child("gameByPost/\(postID)")
//        pathToGame = FirebaseHelper.rootRef.child("gameByPost/-KMAUfWSciJE_jnyOPhG")
                startOtherPlayersObserver()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startOtherPlayersObserver()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        points += 1
        updateDB()
		livePointUpdate.text=String(points)
    }
    
    func updateDB(){
//        print("uid by getUid: \(getuid()) uid by FIRAuth: \(FIRAuth.auth()?.currentUser?.uid)")
        let pathToGameThisUser = pathToGame!.child((FIRAuth.auth()?.currentUser?.uid)!)
        pathToGameThisUser.setValue(points)
    }
    
    func startOtherPlayersObserver(){
        
        pathToGame!.queryLimitedToFirst(5)
        pathToGame!.queryOrderedByValue()
        pathToGame!.observeEventType(FIRDataEventType.Value) { (snapshot: FIRDataSnapshot) in
//            var i = 0
            for (index, snap) in snapshot.children.enumerate(){
                
                let s = snap as! FIRDataSnapshot
                print("val: \(s.value!)")
                (self.labelArray[index] as! UILabel).text = String(s.value!)

                let toUser = FirebaseHelper.rootRef.child("user/\(s.key)")
                toUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print(index)
//                    let n = (FIRAuth.id ?? "could not find user name")!
                    let n = (snapshot.value!["username"] ?? "could not find user name")!
                    (self.nameArray[index] as! UILabel).text = String(n)
                })
            }
        }
    }
}
