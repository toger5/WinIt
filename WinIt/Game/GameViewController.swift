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
    
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var livePointUpdate: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
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
    
    
    var post: Post? = nil
    var points = 0
    var clock: CountDownLabelHelper? = nil
    var pathToGame: FIRDatabaseReference? = nil
    var labelArray = []
    var nameArray = []
    
    override func viewDidLoad() {
        pathToGame = FirebaseHelper.rootRef.child("gameByPost/\(post!.key)")
        super.viewDidLoad()
        clock = CountDownLabelHelper(timeInSeconds: (post?.getTimeLeftInSeconds())!, countDownCallback: clockTick)
        setPointsIfAlredyPlayed()
        labelArray = [p1,p2,p3,p4,p5]
        nameArray = [name1,name2,name3,name4,name5]
        
        
        startOtherPlayersObserver()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startOtherPlayersObserver()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        points -= 1
        updateDB()
        FirebaseHelper.getWinnerOfPost(post!) { (username, userKey) in
            self.livePointUpdate.text = username
        }
//        livePointUpdate.text = String(-points)
    }
    
    func updateDB(){
        //        print("uid by getUid: \(getuid()) uid by FIRAuth: \(FIRAuth.auth()?.currentUser?.uid)")
        let pathToGameThisUser = pathToGame!.child((FIRAuth.auth()?.currentUser?.uid)!)
        pathToGameThisUser.setValue(points)
    }
    func clockTick(){
        self.timerLabel.text = self.clock!.getTimeString()
        if self.clock?.wholeTimeInSeconds() <= 0{
            eventStop()
        }
    }
    
    func eventStop(){
        clock?.stop()
        clickButton.enabled = false
        
    }
    
    func startOtherPlayersObserver(){
        pathToGame!.queryOrderedByValue().queryLimitedToFirst(5).observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            
            for (index, snap) in snapshot.children.enumerate(){
                
                let s = snap as! FIRDataSnapshot
                print("val: \(s.value!)")
                let pnts = s.value! as! Double
                (self.labelArray[index] as! UILabel).text = String(-pnts)
                
                let toUser = FirebaseHelper.rootRef.child("users/\(s.key)")
                toUser.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print(index)
                    //                    let n = (FIRAuth.id ?? "could not find user name")!
                    let n = (snapshot.value!["username"] ?? "could not find user name")!
                    (self.nameArray[index] as! UILabel).text = "\(index + 1). \(n)"
                })
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        clock?.stop()
        print("backSegue")
    }
    func setPointsIfAlredyPlayed(){
        pathToGame!.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.hasChild(FirebaseHelper.userID){
                self.points = (snapshot.childSnapshotForPath(FirebaseHelper.userID).value! as! Int) ?? 0
                self.livePointUpdate.text = String(-self.points)            }
        })
    }
}
