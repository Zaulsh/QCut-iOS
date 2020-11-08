//
//  ServiceTableViewCell.swift
//  QCut
//
//  Created by JinYC on 3/12/20.
//  Copyright © 2020 JinYC. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameUL: UILabel!
    @IBOutlet weak var priceUL: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initWithData(serviceName: String, price: String) {
        nameUL.text = serviceName
        priceUL.text = price
    }
    
}
