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
    var time: String
    var picture:UIImage?
    var description:String
    
    init(){
        time = ""
        key = ""
        name = "unknown"
        user = "user"
        picture = nil
        description = "unknown"
    }
    
    init(name: String, picture:UIImage?, description:String, key:String = "", time: String, user: String){
        self.key = key
        self.time = time
        self.name = name
        self.user = user
        self.description = description
        self.picture = picture
    }
    
    init(snapshot: FIRDataSnapshot){
        self.time = snapshot.value!["time"] as! String
        self.key = snapshot.key
        self.user = ""
        self.name = snapshot.value!["name"] as! String
        self.description = ""
        self.picture = nil
    }
    
    func toDict() -> [String:String]{
        let dictionary: [String:String] = [
            "name" : name,
            "user" : user,
            "time" : time,
            "description" : description
        ]
        return dictionary
    }
}