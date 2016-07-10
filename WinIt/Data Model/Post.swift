//
//  File.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//
enum EventStatus: Int{
    case Waiting, Running, Complete, Archived
}

import UIKit
import Firebase
class Post{
    
    var key: String
    var user: String
    var name: String
    var eventTime: Double
    let uploadTime: Double
    var image: UIImage?
    var description: String
    var liked: Bool {
        didSet {
            cell?.updateLiked()
        }
    }
    let eventLength = 60 //in seconds
    let outDatedTime = 60 * 10
    var cell: MainTableViewCell?
    
    
    init() {
        eventTime = 0
        uploadTime = 0
        key = ""
        name = "unknown"
        user = "user"
        image = nil
        description = "unknown"
        liked = false
    }
    
    init(name: String, image:UIImage?, description: String, eventTime: Double, user: String){
        print("new")
        self.uploadTime = Global.getTimeStamp()
        self.eventTime = NSDate(timeIntervalSince1970: uploadTime).dateByAddingTimeInterval(eventTime).timeIntervalSince1970
        self.name = name
        self.user = user
        self.description = description
        self.image = image
        self.liked = false
        self.key = ""
    }
    
    init(snapshot: FIRDataSnapshot){
        print("acces")
        self.uploadTime = snapshot.value!["uploadTime"] as! Double
        self.eventTime = snapshot.value!["eventTime"] as! Double
        self.key = snapshot.key
        print("user key: \(key)")
        self.user = ""
        self.name = snapshot.value!["name"] as! String
        self.description = ""
        self.image = nil
        self.liked = false
    }
    
    func isPlaceHolderImage() -> Bool {
        return image == UIImage(named: "NoImage")
    }
    
    func getTimeLeftInSeconds() -> Double{
        let currentTime = Global.getTimeStamp()
        return eventTime - currentTime
    }
    
    func getState() -> EventStatus{
        if Global.getTimeStamp() < eventTime{
            return EventStatus.Waiting
        }else if Int(Global.getTimeStamp()) < Int(eventTime) + eventLength{
            return EventStatus.Running
        }else if Int(Global.getTimeStamp()) > Int(eventTime) + outDatedTime{
            return EventStatus.Archived
        }else{
            return EventStatus.Complete
        }
    }

    func getTimeLeftHoursMinutesSecondsArray() -> [Int]{
        let timeLeft = getTimeLeftInSeconds()
        let array = [Int(timeLeft / 60 / 60),Int((timeLeft%(60 * 60)) / 60),Int(timeLeft%60)]
        return array
    }
    
    func toDict() -> [String:AnyObject]{
        let dictionary: [String:AnyObject] = [
            "name" : name,
            "user" : user,
            "eventTime" : eventTime,
            "uploadTime": uploadTime,
            "description" : description
        ]
        return dictionary
    }
    
    func setLiked(liked: Bool) {
        
        if self.liked != liked {
            
            self.liked=liked
            
            if liked {
                
                FirebaseHelper.addLike(self)
                
            } else {
                
                FirebaseHelper.removeLike(self)
            }
        }
    }
}