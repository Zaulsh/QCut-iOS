//
//  BarberShop.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import CoreLocation

class BarberShop {
    var id: String
    var street1: String
    var street2: String
    var gMapLink: String
    var shopName: String
    var city: String
    var status: String
    var country: String
    var email: String
    var distance: Double
    
    
    init() {
        id = ""
        street1 = ""
        street2 = ""
        gMapLink = ""
        shopName = ""
        city = ""
        status = ""
        country = ""
        email = ""
        distance = 0.0
    }
    
    func fromFirebase(data: [String: Any], myLocation: CLLocation) {
        id = data["key"] as! String
        street1 = data["addressLine1"] as! String
        street2 = data["addressLine2"] as! String
        gMapLink = data["gmapLink"] as! String
        shopName = data["shopName"] as! String
        city = data["city"] as! String
        status = data["status"] as! String
        country = data["country"] as! String
        email = data["email"] as! String
        
        if gMapLink.count == 0 {
            distance = 0.0
        } else {
            let lat = gMapLink.components(separatedBy: ",")[0]
            let lon = gMapLink.components(separatedBy: ",")[1]
            
            let barberLocation = CLLocation(latitude: Double(lat)!, longitude: Double(lon)!)
            distance = myLocation.distance(from: barberLocation)
        }
    }
}
