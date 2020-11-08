//
//  UIColorExtension.swift
//  oneapp
//
//  Created by Aira on 3/5/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func hexStringToUIColor(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    class func mainRed() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#FF0000")
    }
    
    class func mainBlue() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#0081D6")
    }
    
    class func secondaryBlue() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#007AFF")
    }
    
    class func mainGreen() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#00C0A2")
    }
    
    class func mainOrange() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#FF9100")
    }
    
    class func mainGray() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#ACACAC")
    }
    
    class func btnBottomGray() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#E1E1E1")
    }
    
    class func btnTopGray() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#F1F1F1")
    }
    
    class func mainBorder() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#B7D4DE")
    }
    
    class func greenGradient1() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#4CBF0B")
    }
    
    class func greenGradient2() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#83DE48")
    }
    
    class func yellowGradient1() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#E85D00")
    }
    
    class func yellowGradient2() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "#FF9131")
    }
}

