//
//  File.swift
//  WinIt
//
//  Created by Timo on 05/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import UIKit
class Offer{
    var name: String
    var picture:UIImage?
    var description:String
    var shippingCostIncluded: Bool
    
    init(){
        name = "unknown"
        picture = nil
        description = "unknown"
        shippingCostIncluded = false
    }
    
    init(name: String, picture:UIImage?, description:String, shippingCostIncluded: Bool){
        self.name = name
        self.description = description
        self.picture = picture
        self.shippingCostIncluded = shippingCostIncluded
    }
    
}