//
//  ProfileVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var profileOutLet: UIView!
    @IBOutlet weak var avatarUIMG: UIImageView!
    @IBOutlet weak var cameraUIMG: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var locationLB: UILabel!
        
    @IBOutlet weak var logoutUIV: UIView!
    var location = String()
    var locations = ["Doublin 10","Dublin 11","Dublin 12","Dublin 13","Dublin 14","Dublin 15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserDefaultManager.getBoolData(key: UserDefaultManager.IS_LOGGEDIN) {
            initUIView()
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: newViewController)
            navigationController.navigationBar.isHidden = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
        }
        
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
        
        avatarUIMG.roundCorners(corners: [.allCorners], radius: avatarUIMG.frame.height / 2)
        
        nameLB.text = UserDefaultManager.getStringData(key: UserDefaultManager.USER_NAME)
        emailLB.text = UserDefaultManager.getStringData(key: UserDefaultManager.USER_EMAIL)
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(onTapLogout))
        logoutUIV.setShadowRadiusToUIView()
        logoutUIV.addGestureRecognizer(tapLogout)
        
        profileOutLet.setShadowRadiusToUIView()
    }
    
    @objc func onTapLogout() {
        try! Auth.auth().signOut()
        UserDefaultManager.setBoolData(key: UserDefaultManager.IS_LOGGEDIN, val: false)
        UserDefaultManager.removeData(key: UserDefaultManager.USER_NAME)
        UserDefaultManager.removeData(key: UserDefaultManager.USER_EMAIL)
        UserDefaultManager.removeData(key: UserDefaultManager.USER_ID)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navigationController = UINavigationController(rootViewController: newViewController)
        navigationController.navigationBar.isHidden = true
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navigationController
    }
    
    @objc func onTapNamePen() {
        self.onShowEditVC(type: 0)
    }
    
    @objc func onTapPasswrodPen() {
        self.onShowEditVC(type: 1)
    }
    
    @objc func onTapLocationPen() {
        self.onShowEditVC(type: 2)
    }
    @IBAction func onTapLocationEdit(_ sender: Any) {
        self.onShowEditVC(type: 2)
    }
    
    func onShowEditVC(type: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileEditVC") as! ProfileEditVC
        vc.modalPresentationStyle = .fullScreen
        vc.type = type
        self.present(vc, animated: true, completion: nil)
    }

}

