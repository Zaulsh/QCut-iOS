//
//  TextField.swift
//  oneapp
//
//  Created by Aira on 3/5/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

extension MDCTextInputControllerOutlined{
    func setMDCTextInputOutline(){
        self.activeColor = UIColor.mainBlue()///underline active color
        self.normalColor = .black///underline initial color
        self.underlineHeightActive = 1.0///underline active height
        self.inlinePlaceholderColor = UIColor.gray
        self.floatingPlaceholderNormalColor = UIColor.mainBlue()
        self.floatingPlaceholderActiveColor = UIColor.mainBlue()
    }
}

extension MDCTextField {
    func passwordValidation()->Bool {
        if (self.text!.count >= 6) {
            return true
        } else{
            return false
        }
    }
    
    func emailValidation()->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text)
    }
    
    func usernameEmptyCheck()-> Bool{
        if (self.text!.count <= 0) {
            return true
        } else{
            return false
        }
    }
}
