//
//  BarbershopCell.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import CoreLocation

protocol BarberShopCellDelegate {
    func onTapCell(barberShop: BarberShop)
}

class BarbershopCell: UITableViewCell {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var street1UL: UILabel!
    @IBOutlet weak var street2UL: UILabel!
    
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var favouriteUV: UIView!
    @IBOutlet weak var favouriteUL: UILabel!
    @IBOutlet weak var distabceUL: UILabel!
    @IBOutlet weak var containerUV: UIView!
    @IBOutlet weak var statusUIMG: UIImageView!
    
    var barberShop: BarberShop = BarberShop()
    var delegate: BarberShopCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favouriteUV.layer.cornerRadius = favouriteUV.frame.height / 2
        
        containerUV.setShadowRadiusToUIView()
        
        let tapContainer = UITapGestureRecognizer(target: self, action: #selector(onTapContainerUV))
        containerUV.addGestureRecognizer(tapContainer)
    }
    
    @objc func onTapContainerUV() {
        self.delegate?.onTapCell(barberShop: barberShop)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initWithData(barber: BarberShop) {
        self.barberShop = barber
        
        shopName.text = barber.shopName
        street1UL.text = barber.street1
        street2UL.text = barber.street2 + ", " + barber.city
        
        distabceUL.text = String(format: "%.1f", barber.distance / 1000) + " Km"
        
        if barber.status == "OFFLINE" {
            statusUIMG.image = UIImage(named: "ic_offline")
        } else if barber.status == "ONLINE" {
            statusUIMG.image = UIImage(named: "ic_online")
        }
    }
    
}
