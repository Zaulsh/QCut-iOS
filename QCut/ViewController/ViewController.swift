//
//  ViewController.swift
//  QCut
//
//  Created by JinYC on 3/12/20.
//  Copyright © 2020 JinYC. All rights reserved.
//

import UIKit
import IMSegmentPageView
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var street1: UILabel!
    @IBOutlet weak var street2: UILabel!
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var likesUV: UIView!
    
    @IBOutlet weak var distanceUL: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var segmentUV: UIView!
    @IBOutlet weak var statusUIMG: UIImageView!
    
    var titleView: IMSegmentTitleView?
    var pageView: IMPageContentView?
    var barberShop: BarberShop = BarberShop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.setShadowRadiusToUIView()
        self.view.bringSubviewToFront(topView)
        
        initUIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let property = IMSegmentTitleProperty()
        property.indicatorHeight = 1
        property.indicatorType = .width
        property.indicatorColor = UIColor.black
        property.indicatorExtension = segmentUV.frame.width / 3.0 - 30.0
        property.isLeft = false
        property.showBottomLine = false
        property.titleNormalColor = UIColor.black
        property.titleSelectColor = UIColor.black
        property.titleNormalFont = UIFont(name:"HelveticaNeue", size: 14.0)!
        property.titleSelectFont = UIFont(name:"HelveticaNeue", size: 14.0)!
        
        let titles = ["SERVICES", "HOURS", "DETAILS"]
        let titleFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 45.0)
        titleView = IMSegmentTitleView(frame: titleFrame, titles: titles, property: property)
        titleView!.backgroundColor = .white
        titleView!.delegate = self
        segmentUV.addSubview(titleView!)
        
        shopName.text = barberShop.shopName
        street1.text = barberShop.street1
        street2.text = barberShop.street2 + ", " + barberShop.city
    
        distanceUL.text = String(format: "%.1f", barberShop.distance / 1000) + " Km"
        
        statusUIMG.image = barberShop.status == "ONLINE" ? UIImage(named: "ic_online") : UIImage(named: "ic_offline")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
        vc1.barberShop = barberShop
        let vc2 = storyboard.instantiateViewController(withIdentifier: "QueueViewController") as! QueueViewController
        vc2.barberShop = barberShop
        let vc3 = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc3.barberShop = barberShop
        
        let childVCs: [UIViewController] = [vc1, vc2, vc3] // viewControllers
        let contentFrame = CGRect(x: 0.0, y: 45.0, width: segmentUV.bounds.size.width, height: segmentUV.bounds.size.height - 45.0)
        
        vc1.preferredContentSize = contentFrame.size
        vc2.preferredContentSize = contentFrame.size
        vc3.preferredContentSize = contentFrame.size
        
        pageView = IMPageContentView(Frame: contentFrame, childVCs: childVCs, parentVC: self)
        pageView?.delegate = self
        segmentUV.addSubview(pageView!)
    }
    
    func initUIView() {
//        locationUV.layer.cornerRadius = 20.0
//        locationUV.layer.borderColor = UIColor.yellow.cgColor
//        locationUV.layer.borderWidth = 2.0
//        
//        likesUV.layer.cornerRadius = 20.0
//        likesUV.layer.borderColor = UIColor.yellow.cgColor
//        likesUV.layer.borderWidth = 2.0
    }

}

extension ViewController: IMPageContentDelegate {
    
    func contentViewDidScroll(_ contentView: IMPageContentView, startIndex: Int, endIndex: Int, progress: CGFloat) {
        //
    }
    
    func contenViewDidEndDecelerating(_ contentView: IMPageContentView, startIndex: Int, endIndex: Int) {
        titleView?.selectIndex = endIndex
    }
    
}

extension ViewController: IMSegmentTitleViewDelegate {
    
    func segmentTitleView(_ titleView: IMSegmentTitleView, startIndex: Int, endIndex: Int) {
        pageView?.contentViewCurrentIndex = endIndex
    }
    
}

