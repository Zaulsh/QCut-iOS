//
//  SearchVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class SearchVC: UIViewController {

    @IBOutlet weak var changeUV: UIView!
    @IBOutlet weak var nearestUB: UIButton!
    @IBOutlet weak var onlineUB: UIButton!
    @IBOutlet weak var barberShopTV: UITableView!
    
    var barberShopArr = [BarberShop]()
    var sortedBarberShopArr = [BarberShop]()
    
    var isSelectNearestTab = true
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
            Global.lat = currentLoc.coordinate.latitude
            Global.lon = currentLoc.coordinate.longitude
        }

        initData()
        initUIView()
        initTapSwitcher()
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initData() {

        let myLocation = CLLocation(latitude: Global.lat, longitude: Global.lon)
        
        Global.onShowProgressView(name: "Loading")
        FireManager.getDataToFirebase(ref: FireManager.shopDetailRef, success: {snap in
            self.barberShopArr.removeAll()
            for child in snap.children {
                Global.onhideProgressView()
                let snapChild = child as! DataSnapshot
                let barberShop = BarberShop()
                let postDict = snapChild.value as? [String: Any] ?? [:]
                barberShop.fromFirebase(data: postDict, myLocation: myLocation)
                self.barberShopArr.append(barberShop)
            }
            if self.isSelectNearestTab {
                self.sortedBarberShopArr = self.barberShopArr.sorted(by: {$0.distance < $1.distance})
            } else {
                self.sortedBarberShopArr = self.barberShopArr.sorted(by: {$0.status > $1.status})
            }
            self.barberShopTV.reloadData()
        })

        if UserDefaultManager.getBoolData(key: UserDefaultManager.IS_LOGGEDIN) {
            FireManager.getUserQueueStatus(userID: UserDefaultManager.getStringData(key: UserDefaultManager.USER_ID), success: {(isqueued) in
                Global.isQueued = isqueued
            })
        }
        
        
        if Global.gBarbershopID.count > 0 {
            let childPath = Global.BARBER_WAITING_QUEUES + "/" + Global.gBarbershopID
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
                }
            })
            
            FireManager.getDataToFirebase(ref: FireManager.shopDetailRef.child(Global.gBarbershopID), success: {snap in
                let data = snap.value as? [String: Any] ?? [:]
                let barbershop = BarberShop()
                barbershop.fromFirebase(data: data, myLocation: myLocation)
                Global.gBarberShop = barbershop
            })
        }
    }
    
    func initUIView() {
        barberShopTV.register(UINib(nibName: "BarbershopCell", bundle: nil), forCellReuseIdentifier: "BarbershopCell")
        barberShopTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        barberShopTV.rowHeight = UITableView.automaticDimension
        barberShopTV.dataSource = self
        barberShopTV.delegate = self
        
        changeUV.layer.cornerRadius = changeUV.frame.height / 2
        changeUV.layer.borderColor = UIColor.secondaryBlue().cgColor
        changeUV.layer.borderWidth = 2.0
    }
    
    func initTapSwitcher() {
        if isSelectNearestTab {
            nearestUB.backgroundColor = UIColor.secondaryBlue()
            nearestUB.setTitleColor(UIColor.white, for: .normal)
            onlineUB.backgroundColor = UIColor.white
            onlineUB.setTitleColor(UIColor.black, for: .normal)
        } else {
            onlineUB.backgroundColor = UIColor.secondaryBlue()
            onlineUB.setTitleColor(UIColor.white, for: .normal)
            nearestUB.backgroundColor = UIColor.white
            nearestUB.setTitleColor(UIColor.black, for: .normal)
        }
    }

    @IBAction func onTapNearestUB(_ sender: Any) {
        isSelectNearestTab = true
        initTapSwitcher()
        initData()
    }
    
    @IBAction func onTapOnlineUB(_ sender: Any) {
        isSelectNearestTab = false
        initTapSwitcher()
        initData()
    }
    
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedBarberShopArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarbershopCell", for: indexPath) as! BarbershopCell
        cell.delegate = self
        cell.initWithData(barber: sortedBarberShopArr[indexPath.row])
        return cell
    }
    
    
}

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension SearchVC: BarberShopCellDelegate {
    func onTapCell(barberShop: BarberShop) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.barberShop = barberShop
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


