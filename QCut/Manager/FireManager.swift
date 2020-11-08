//
//  FireManager.swift
//  QCut
//
//  Created by Aira on 5/20/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseInstanceID
import FirebaseMessaging

class FireManager {
    
    static var queueRef: DatabaseReference = Database.database().reference().child("barberWaitingQueues")
    static var customerRef: DatabaseReference = Database.database().reference().child("Customers")
    static var barberRef: DatabaseReference = Database.database().reference().child("barbers")
    static var shopDetailRef: DatabaseReference = Database.database().reference().child("shopDetails")
    static var customerViewRef: DatabaseReference = Database.database().reference().child("customerView")
    static var serviceRef: DatabaseReference = Database.database().reference().child("servicesAvailable")
    
    static func saveNewToken(userID: String, token: String) {
        let udid = UIDevice.current.identifierForVendor?.uuidString
//        InstanceID.instanceID().instanceID{(result, error) in
//            if error == nil {
//                let token = result?.token
//                let params = ["fcmTokens": token]
//                customerRef.child(userID).child("notificationFirebaseTokens").setValue(params)
//            }
//        }
//        let token = Messaging.messaging().fcmToken
        let params = ["fcmTokens": token]
        customerRef.child(userID).child("notificationFirebaseTokens").setValue(params)
    }
    
    static func saveDataToFirebase(ref: DatabaseReference, params: [String: AnyObject], success: @escaping ((Bool) -> Void)) {
        ref.setValue(params) {(error, ref) -> Void in
            if error == nil {
                success(true)
            } else {
                success(false)
            }
        }
    }
    
    static func getDataToFirebase(ref: DatabaseReference, success: @escaping ((DataSnapshot) -> Void)) {
        ref.observeSingleEvent(of: .value, with: {snapshot in
            success(snapshot)
        })
    }
    
    static func getUserQueueStatus(userID: String, success: @escaping ((Bool) -> Void)) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let curDate = formatter.string(from: date)
        
        queueRef.observeSingleEvent(of: .value, with: {snapshot in
            for firstLevel in snapshot.children {
                let firstLevelData = firstLevel as! DataSnapshot
                if firstLevelData.key.contains(curDate) {
                    queueRef.child(firstLevelData.key).observeSingleEvent(of: .value, with: {snap in
                        for secondLevel in snap.children {
                            let secondLevelData = secondLevel as! DataSnapshot
                            if secondLevelData.hasChild(userID) {
                                let data = secondLevelData.value as! [String: AnyObject]
                                
                                
                                
                                let userData = data[userID] as! [String: AnyObject]
                                let userStatus = userData["status"] as! String
                                if userStatus == Global.Suit.queue.rawValue || userStatus == Global.Suit.progress.rawValue {
                                    Global.gBarbershopID = firstLevelData.key
                                    success(true)
                                } else {
                                    success(false)
                                }
                            }
                        }
                    })
                }
            }
        })
    }
}
