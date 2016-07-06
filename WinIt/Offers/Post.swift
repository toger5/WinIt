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
    var name: String
    var time: String
    var picture:UIImage?
    var description:String
    var shippingCostIncluded: Bool
    
    init(){
        time = ""
        key = ""
        name = "unknown"
        picture = nil
        description = "unknown"
        shippingCostIncluded = false
    }
    
    init(name: String, picture:UIImage?, description:String, shippingCostIncluded: Bool, key:String = "", time: String){
        self.key = key
        self.time = time
        self.name = name
        self.description = description
        self.picture = picture
        self.shippingCostIncluded = shippingCostIncluded
    }
    
    init(snapshot: FIRDataSnapshot){
        self.time = snapshot.value!["time"] as! String
        self.key = snapshot.key
        self.name = snapshot.value!["name"] as! String
        self.description = ""
        self.picture = nil
        self.shippingCostIncluded = false
    }
    
    func toDict() -> [String:String]{
        let dictionary: [String:String] = [
            "name" : name,
            "time" : time,
            "description" : description
        ]
        return dictionary
    }
}