//
//  UsernameValidator.swift
//  WinIt
//
//  Created by Steven on 7/12/16.
//  Copyright © 2016 Timo. All rights reserved.
//

import Foundation

struct UsernameValidator {
    
    /// Checks if username only uses valid characters: A-Z, a-z, and _
    static func invalidCharactersIn(username: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890")
        return username.rangeOfCharacterFromSet(characterSet.invertedSet) != nil
    }
    
    /// Checks if username is between 4 & 15 characters
    static func usernameInvalidLength(username: String) -> Bool {
        return username.characters.count < 4 || username.characters.count > 15
    }
}