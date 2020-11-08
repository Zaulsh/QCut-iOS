//
//  ServicesViewController.swift
//  QCut
//
//  Created by JinYC on 3/12/20.
//  Copyright © 2020 JinYC. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ServicesViewController: UIViewController {
    
    @IBOutlet weak var queueUV: UIView!
    @IBOutlet weak var offlineUB: UIButton!
    
    @IBOutlet weak var serviceUTV: UITableView!
    
    var barberShop: BarberShop = BarberShop()
    var serviceNameArr = [String]()
    var servicePriceArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serviceUTV.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceTableViewCell")
        
        initUIView()
    }
    
    func initUIView() {
        
        queueUV.setShadowRadiusToUIView(radius: 20.0)
        offlineUB.setShadowRadiusToUIView()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapJoin))
        queueUV.addGestureRecognizer(gesture)
        if barberShop.status == "ONLINE" {
            offlineUB.isHidden = true
            queueUV.isHidden = false
        } else {
            offlineUB.isHidden = false
            queueUV.isHidden = true
        }
        Global.onShowProgressView(name: "Loading")
        
        FireManager.getDataToFirebase(ref: FireManager.serviceRef.child(barberShop.id), success: {(snap) in
            self.serviceNameArr.removeAll()
            self.servicePriceArr.removeAll()
            Global.onhideProgressView()
            for child in snap.children {
                let snapChild = child as! DataSnapshot
                let serviceData = snapChild.value as? [String: Any] ?? [:]
                let serviceName = serviceData["serviceName"] as! String
                let servicePrice = serviceData["servicePrice"] as! String
                self.serviceNameArr.append(serviceName)
                self.servicePriceArr.append("€ " + servicePrice)
            }
            self.serviceUTV.reloadData()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func onTapJoin() {
        if !UserDefaultManager.getBoolData(key: UserDefaultManager.IS_LOGGEDIN) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: newViewController)
            navigationController.navigationBar.isHidden = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
        } else {
            
            let pushManager = PushNotificationManager(userID: UIDevice.current.identifierForVendor!.uuidString)
            
            pushManager.registerForPushNotifications()
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyy"
            let curDate = formatter.string(from: date)
            
            Global.waitingTime = 0
            
            Global.onShowProgressView(name: "Loading")
            let childPath = Global.BARBER_WAITING_QUEUES + "/" + barberShop.id + "_" + curDate
            Database.database().reference().child(childPath).observeSingleEvent(of: .value, with: {snap in
                if(snap.exists()){
                    var desiredBarberKey: String = ""
                    var latestArrivalTimeLong: CLong = 0
                    var placeInQueue: Int = 0
                    
                    for barbers in snap.children {
                        let aBarber = barbers as! DataSnapshot
                        for customers in aBarber.children {
                            let customer: DataSnapshot = customers as! DataSnapshot
                            desiredBarberKey = aBarber.key
                            let customerSnap = customer.value as! [String: AnyObject]
                            let status = customerSnap["status"] as! String
                            
                            if (status == Global.Suit.queue.rawValue) {
                                placeInQueue +=  1;
                                let arrivalTime = customerSnap["arrivalTime"] as! CLong
                                let arrivalTimeLong = CLong(arrivalTime)
                                if (latestArrivalTimeLong < arrivalTimeLong) {
                                    latestArrivalTimeLong = arrivalTimeLong
                                    Global.waitingTime = customerSnap["expectedWaitingTime"] as! CLong
                                }
                            }
                        }
                    }
                    Global.onhideProgressView()
                    placeInQueue += 1
                    Global.waitingTime = Global.waitingTime + 15
                    self.pushCustomerToQueue(shopKey: self.barberShop.id, desiredBarberKey: desiredBarberKey, maxWaitingTime: Global.waitingTime, placeInQueue: placeInQueue)
                    
                    Global.isQueued = true
                    Global.gBarberShop = self.barberShop
                    self.tabBarController?.selectedIndex = 1
                    self.navigationController?.popToRootViewController(animated: false)
                } else {
                    Global.onhideProgressView()
                    Database.database().reference().child(Global.BARBERS).child(self.barberShop.id).queryOrdered(byChild: "queueStatus").queryEqual(toValue: "OPEN")
                        .observeSingleEvent(of: .value, with: {snap in
                            Global.onhideProgressView()
                            for child in snap.children {
                                let barber = child as! DataSnapshot
                                let desiredBarberKey = barber.key
                                self.pushCustomerToQueue(shopKey: self.barberShop.id, desiredBarberKey: desiredBarberKey, maxWaitingTime: 0, placeInQueue: 1)
                            }
                            Global.isQueued = true
                            Global.gBarberShop = self.barberShop
                            self.tabBarController?.selectedIndex = 1
                            self.navigationController?.popToRootViewController(animated: false)
                        })
                   }
            })
        }
        
        
    }
    
    func pushCustomerToQueue(shopKey: String, desiredBarberKey: String, maxWaitingTime: CLong , placeInQueue: Int) {
        let customerKey = UserDefaultManager.getStringData(key: UserDefaultManager.USER_ID)
        
        let timestamp = NSDate().timeIntervalSince1970
        let curTime = String(format: "%.0f", timestamp)
        let curtimeLong = CLong(curTime)
        let queue: String = Global.Suit.queue.rawValue
        
        let customerToQueue = [
            "absent": false,
            "actualBarberId": desiredBarberKey,
            "actualProcessingTime": 0,
            "anyBarber": true,
            "addedBy": customerKey,
            "arrivalTime": curtimeLong!,
            "departureTime": 0,
            "dragAdjustedTime": 0,
            "expectedWaitingTime": maxWaitingTime,
            "key": customerKey,
            "channel": "CUSTOMER_APP",
            "lastPositionChangedTime": 0,
            "placeInQueue": placeInQueue,
            "serviceStartTime": 0,
            "serviceTime": 0,
            "status": queue,
            "timeAdded": -1,
            "customerId": customerKey,
            "name": UserDefaultManager.getStringData(key: UserDefaultManager.USER_NAME)
            ] as [String : Any]
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let curDate = formatter.string(from: date)
        let childPath = Global.BARBER_WAITING_QUEUES + "/" + shopKey + "_" + curDate
    Database.database().reference().child(childPath).child(desiredBarberKey).child(customerKey).setValue(customerToQueue)
    }

}

extension ServicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell", for: indexPath) as! ServiceTableViewCell
        cell.initWithData(serviceName: serviceNameArr[indexPath.row], price: servicePriceArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ServicesViewController: UITableViewDelegate {
    
}

extension ServicesViewController: SelectBarberDelegate {
    func dismissDelegate() {
        print("dismiss")
        Global.isQueued = true
        self.tabBarController?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
}
