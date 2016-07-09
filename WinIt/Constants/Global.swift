//
//  Global.swift
//  WinIt
//
//  Created by Timo on 08/07/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Foundation
class Global{
    static var timeOffset: Double = 0.0
    static func getTimeStamp() -> Double{
        return NSDate().timeIntervalSince1970 + timeOffset
    }
}