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
class GameViewController{
    
    var points = 0
    
    @IBAction func buttonPressed(sender: AnyObject) {
        points += 1
    }
    
    func updateDB(){
        print("uid by getUid: \(getuid()) uid by FIRAuth: \(FIRAuth.auth()?.currentUser?.uid)")
        FirebaseHelper.rootRef.child("gameByPost").child((FIRAuth.auth()?.currentUser?.uid)!)
    }
}
