//
//  File.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
import Firebase
class Post{
    
    var key: String
    var user: String
    var name: String
    var time: Double
    let uploadTime: Double
    var picture:UIImage?
    var description:String
    
    init(){
        time = 0
        uploadTime = 0
        key = ""
        name = "unknown"
        user = "user"
        picture = nil
        description = "unknown"
    }
    
    init(name: String, picture:UIImage?, description:String, key:String = "", time: Double, user: String){
        self.uploadTime = NSDate().timeIntervalSince1970
        self.key = key
        self.time = time
        self.name = name
        self.user = user
        self.description = description
        self.picture = picture
    }
    
    init(snapshot: FIRDataSnapshot){
        self.uploadTime = snapshot.value!["uploadTime"]
        self.time = snapshot.value!["time"]
        self.key = snapshot.key
        self.user = ""
        self.name = snapshot.value!["name"] as! String
        self.description = ""
        self.picture = nil
    }
    func getTimeLeftInHours(){
        let timeBetween = NSDate().timeIntervalSinceDate(uploadTime)
        return time - timeBetween
    }
    func getHoursMinutesSecondsArray() -> [Int]{
        let timeLeft = getTimeLeftInHours()
        var array = [Int(timeLeft),Int((timeLeft%1)*60),Int((timeLeft%(1/60)) * 60 * 60)]
    }
    func toDict() -> [String:String]{
        let dictionary: [String:String] = [
            "name" : name,
            "user" : user,
            "time" : time,
            "uploadTime": uploadTime,
            "description" : description
        ]
        return dictionary
    }
}