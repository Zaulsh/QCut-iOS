//
//  SelectBarberVC.swift
//  QCut
//
//  Created by Aira on 3/13/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit

protocol SelectBarberDelegate {
    func dismissDelegate()
}

class SelectBarberVC: UIViewController {

    @IBOutlet weak var modalUV: UIView!
    @IBOutlet weak var titleUV: UIView!
    @IBOutlet weak var barberPV: UIPickerView!
    @IBOutlet weak var joinUB: UIButton!
    
    var barbers = ["John","Merry","Berk"]
    
    var selectBarberDelegate: SelectBarberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
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
        modalUV.layer.cornerRadius = 5.0
        titleUV.layer.cornerRadius = 5.0
        joinUB.layer.cornerRadius = joinUB.frame.height / 2
        joinUB.layer.borderWidth = 1.0
        joinUB.layer.borderColor = UIColor.mainGreen().cgColor
        
        barberPV.dataSource = self
        barberPV.delegate = self
    }
    
    @IBAction func onTapJoinUB(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.selectBarberDelegate?.dismissDelegate()
    }
    
}

extension SelectBarberVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return barbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return barbers[row]
    }
    
    
}

extension SelectBarberVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(barbers[row])
    }
}
