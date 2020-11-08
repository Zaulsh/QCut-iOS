//
//  ProfileEditVC.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MaterialComponents

class ProfileEditVC: UIViewController {
    
    @IBOutlet weak var titelLB: UILabel!
    @IBOutlet weak var mdcNameTF: MDCTextField!
    @IBOutlet weak var mdcPasswordTF: MDCTextField!
    @IBOutlet weak var mdcNewPwdTF: MDCTextField!
    @IBOutlet weak var locationPV: UIPickerView!
    @IBOutlet weak var saveUB: UIButton!
    @IBOutlet weak var cancelUB: UIButton!
    
    var type: Int = Int()
    var nameMDCController: MDCTextInputControllerOutlined?
    var passwordMDCController: MDCTextInputControllerOutlined?
    var newPwdMDCController: MDCTextInputControllerOutlined?
    
    var nameUB: UIButton!
    var passwordUB: UIButton!
    var newPwdUB: UIButton!
    
    var locationName: String = "Doublin 10"
    
    var locations = ["Doublin 10","Dublin 11","Dublin 12","Dublin 13","Dublin 14","Dublin 15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        saveUB.setShadowRadiusToUIView(radius: 10.0)
        cancelUB.setShadowRadiusToUIView(radius: 10.0)
        initUIView()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initUIView() {
        switch type {
        case 0:
            titelLB.text = "Name"
            mdcNameTF.isHidden = false
            mdcPasswordTF.isHidden = true
            mdcNewPwdTF.isHidden = true
            locationPV.isHidden = true
            break
        case 1:
            titelLB.text = "Password"
            mdcNameTF.isHidden = true
            mdcPasswordTF.isHidden = false
            mdcNewPwdTF.isHidden = false
            locationPV.isHidden = true
            break
        case 2:
            titelLB.text = "Location"
            mdcNameTF.isHidden = true
            mdcPasswordTF.isHidden = true
            mdcNewPwdTF.isHidden = true
            locationPV.isHidden = false
            break
        default:
            break
        }
        
        nameMDCController = MDCTextInputControllerOutlined(textInput: mdcNameTF)
        nameMDCController?.setMDCTextInputOutline()
        nameMDCController?.normalColor = UIColor.mainGreen()
        nameMDCController?.inlinePlaceholderColor = UIColor.mainGreen()
        
        passwordMDCController = MDCTextInputControllerOutlined(textInput: mdcPasswordTF)
        passwordMDCController?.setMDCTextInputOutline()
        passwordMDCController?.normalColor = UIColor.mainGreen()
        passwordMDCController?.inlinePlaceholderColor = UIColor.mainGreen()
        
        newPwdMDCController = MDCTextInputControllerOutlined(textInput: mdcNewPwdTF)
        newPwdMDCController?.setMDCTextInputOutline()
        newPwdMDCController?.normalColor = UIColor.mainGreen()
        newPwdMDCController?.inlinePlaceholderColor = UIColor.mainGreen()
        
        mdcNameTF.clearButton.isHidden = true
        mdcPasswordTF.clearButton.isHidden = true
        mdcNewPwdTF.clearButton.isHidden = true
        
        nameUB = UIButton(type: .custom)
        nameUB.setImage(UIImage.icUserRed(), for: .normal)
        nameUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        nameUB.frame = CGRect(x: mdcNameTF.frame.width - 25, y: 5, width: 25, height: 25)
        mdcNameTF.rightView = nameUB
        mdcNameTF.rightViewMode = .always
        
        passwordUB = UIButton(type: .custom)
        passwordUB.setImage(UIImage.icKeyYellow(), for: .normal)
        passwordUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordUB.frame = CGRect(x: mdcPasswordTF.frame.width - 25, y: 5, width: 34, height: 34)
        mdcPasswordTF.rightView = passwordUB
        mdcPasswordTF.rightViewMode = .always
        
        newPwdUB = UIButton(type: .custom)
        newPwdUB.setImage(UIImage.icKeyYellow(), for: .normal)
        newPwdUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        newPwdUB.frame = CGRect(x: mdcNewPwdTF.frame.width - 25, y: 5, width: 25, height: 25)
        mdcNewPwdTF.rightView = newPwdUB
        mdcNewPwdTF.rightViewMode = .always
        
        locationPV.dataSource = self
        locationPV.delegate = self
    }
    
    @IBAction func onClickSaveUB(_ sender: Any) {
        switch type {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
//            Global.gUser.location = locationName
//        Database.database().reference().child("Customers").child(Global.gUser.id).setValue(Global.gUser.toFirebaseData())
            break
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickCancelUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileEditVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
}

extension ProfileEditVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationName = locations[row]
    }
}
