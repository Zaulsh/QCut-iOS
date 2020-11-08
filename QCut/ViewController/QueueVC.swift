//
//  QueueVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QueueVC: UIViewController {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var street1: UILabel!
    @IBOutlet weak var street2: UILabel!
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var favoriteUV: UIView!
    @IBOutlet weak var scheduleTimeUV: UIView!
    @IBOutlet weak var scheduleTimeLB: UILabel!
    @IBOutlet weak var leaveUB: UIView!
    @IBOutlet weak var leaveLB: UILabel!
    
    @IBOutlet weak var unqueUV: UIView!
    
    @IBOutlet weak var dearLB: UILabel!
    @IBOutlet weak var waitingLB: UILabel!
    @IBOutlet weak var topUV: UIView!
    @IBOutlet weak var selectBarberUB: UIButton!
    
    var barberShop: BarberShop = BarberShop()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func initUIView(){
        scheduleTimeLB.textColor = UIColor.mainGreen()
        selectBarberUB.setShadowRadiusToUIView(radius: 20.0)
        
        var timeString: String = ""
        if(Global.waitingTime == 0){
            timeString = "Ready"
        }else{
            let hrs = Global.waitingTime / 3600
            let min = Global.waitingTime / 60
            let sec = Global.waitingTime % 60
            
            var hrsString = ""
            var minString = ""
            var secString = ""
            
            if(hrs <= 0){
                hrsString = ""
            }else if(hrs > 0){
                hrsString = String(hrs) + " h "
            }
            
            if(min <= 0){
                minString = ""
            }else if(min > 0){
                minString = String(min) + " min "
            }
            
            if(sec <= 0){
                secString = ""
            }else if(sec > 0){
                secString = String(sec) + " sec "
            }
            timeString = hrsString + minString + secString
        }
        
        scheduleTimeLB.text = timeString
        scheduleTimeUV.setShadowRadiusToUIView(radius: scheduleTimeUV.frame.height / 2)
        scheduleTimeUV.layer.borderColor = UIColor.mainGreen().cgColor
        scheduleTimeUV.layer.borderWidth = 2.0
        
        leaveUB.setShadowRadiusToUIView(radius: leaveUB.frame.height / 2)
        leaveUB.layer.borderColor = UIColor.systemBlue.cgColor
        leaveUB.layer.borderWidth = 1.0
        
        let tapLeaveUB = UITapGestureRecognizer(target: self, action: #selector(onTapLeaveUB))
        leaveUB.addGestureRecognizer(tapLeaveUB)
        
        topUV.setShadowRadiusToUIView()
        
        if Global.isQueued {
            print("queued")
            unqueUV.isHidden = true
            
            barberShop = Global.gBarberShop
            
            shopName.text = barberShop.shopName
            street1.text = barberShop.street1
            street2.text = barberShop.street2 + ", " + barberShop.city
            
        } else {
            print("Unqueued")
            unqueUV.isHidden = false
        }
    }
    @IBAction func onTapSelectBarber(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func onTapLeaveUB() {
        
        let customerId = UserDefaultManager.getStringData(key: UserDefaultManager.USER_ID)
        Global.onhideProgressView()
     
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let curDate = formatter.string(from: date)
        
        let queryPath = Global.BARBER_WAITING_QUEUES + "/" + barberShop.id + "_" + curDate
        
        Database.database().reference().child(queryPath).observeSingleEvent(of: .value, with: {snap in
             Global.onhideProgressView()
             if(snap.exists()){
                for barbers in snap.children {
                    let aBarber = barbers as! DataSnapshot
                    let barberKey = aBarber.key
                    if(aBarber.hasChild(customerId)){
                        Database.database().reference().child(queryPath).child(barberKey).child(customerId).child("status").setValue(Global.Suit.removed.rawValue)
                        
                        Global.isQueued = false
                        self.tabBarController?.selectedIndex = 0
                        
                    }
                }
             }
         })
        
    }
}
