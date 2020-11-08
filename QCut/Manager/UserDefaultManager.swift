//
//  UserDefaultManager.swift
//  QCut
//
//  Created by Aira on 5/20/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation

class UserDefaultManager {
    static var LOGIN_TYPE = "loginType"
    static var IS_LOGGEDIN = "is_loggedin"
    static var USER_NAME = "userName"
    static var USER_EMAIL = "userEmail"
    static var USER_ID = "userID"
    
    static func setStringData(key: String, val: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    static func getStringData(key: String) -> String {
        return UserDefaults.standard.string(forKey: key)!
    }
    
    static func setBoolData(key: String, val: Bool) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    static func getBoolData(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func removeData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
