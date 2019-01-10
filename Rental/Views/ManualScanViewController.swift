//
//  ManualScanViewController.swift
//  PreEMRLite_01
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class ManualScanViewController: UIViewController {

    var emrList: [EMRLine] = []
    //TODO temporarly
    var type: String = "Shipping"
    
    @IBOutlet weak var barcodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeTextField.setBottomBorder()

        let emr1 = EMRLine(_eqId: "EQ008913", _emrId: "EMR003244", _type: "Rental", _direction: "Inbound", _model: "X758", _schedule: "21/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        let emr2 = EMRLine(_eqId: "EQ008912", _emrId: "EMR003242", _type: "Rental", _direction: "Outbound", _model: "X758", _schedule: "25/11/2018", _from: "Raleigh Blueridge Road - Industrial")
        
        emrList.append(emr1)
        emrList.append(emr2)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ManualScanToLineDetailsShow", sender: self)
    }
    
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ManualScanToLineDetailsShow" {
            
            let tempEMRLine = emrList[0]
            
            let emrLineVC = segue.destination as! EMRLineViewController
            
            emrLineVC.type = self.type
            emrLineVC.localEMRLine = tempEMRLine
            
        }
    }
}
