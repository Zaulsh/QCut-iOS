//
//  UIImageExtension.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func icAccount() -> UIImage {
        return UIImage(named: "ic_account")!
    }
    
    class func icEmail() -> UIImage {
        return UIImage(named: "mail_blasck")!
    }
    
    class func icLock() -> UIImage {
        return UIImage(named: "password_off")!
    }
    
    class func icUnlock() -> UIImage {
        return UIImage(named: "password_on")!
    }
    
    class func icUserRed() -> UIImage {
        return UIImage(named: "ic_profile_red")!
    }
    
    class func icKeyYellow() -> UIImage {
        return UIImage(named: "ic_lock_yellow")!
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
