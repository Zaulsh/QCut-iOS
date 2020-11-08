//
//  Global.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import SVProgressHUD
import FirebaseDatabase

class Global: NSObject {
    static var gUser = User()
    static var isQueued = false
    static var gBarberShop = BarberShop()
    static var waitingTime: CLong = 0
    static var gBarbershopID = ""
    
    
    static let BARBER_WAITING_QUEUES: String = "barberWaitingQueues"
    static let BARBERS: String = "barbers"
    
    static var lat = 0.0
    static var lon = 0.0
    
    enum Suit: String, CaseIterable { case queue = "QUEUE"; case progress = "PROGRESS"; case done = "DONE"; case removed = "REMOVED"        
    }
    
    static func onShowProgressView (name: String) {
        SVProgressHUD.show(withStatus: name)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setForegroundColor (UIColor.lightGray)
        SVProgressHUD.setBackgroundColor (UIColor.black.withAlphaComponent(0.0))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingNoTextRadius(20)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
    }
    
    static func onhideProgressView() {
        SVProgressHUD.dismiss()
    }
}
