//
//  EMRLineViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 04..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class EMRLineViewController: UIViewController {

    
    @IBOutlet weak var replaceAttachmentView: UIView!
    
    @IBOutlet weak var eqIdLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    
    
    @IBOutlet weak var fuelTextField: UITextField!
    @IBOutlet weak var smuTextField: UITextField!
    @IBOutlet weak var secsmuTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var localEMRLine: EMRLine!
    var type: String = "Shipping"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "EMRLineToFilteredListShow":
            let emrListVC = segue.destination as! EMRListViewController
            
            emrListVC.type = self.type
            emrListVC.isFilteredEMRList = true
            
        case "EMRLineToAddPhoneShow":
            let photoVC = segue.destination as! AddPhotoViewController
            
            photoVC.type = self.type
            photoVC.localEMRLine = self.localEMRLine
            
        case "EMRLineToReplaceAttachmentShow":
            let replaceVC = segue.destination as! ReplaceAttachmentViewController
            
            replaceVC.localEMRLine = self.localEMRLine
            
            
        default:
            print("Unknow identifier")
        }
    }
    
    func updateUI() {
        
        self.title = self.type + " " + localEMRLine.emrId
        
        //fuelTextField.setBottomBorder()
        //smuTextField.setBottomBorder()
        //secsmuTextField.setBottomBorder()
        //quantityTextField.setBottomBorder()
        
        eqIdLabel.text = localEMRLine.eqId
        typeLabel.text = localEMRLine.type
        directionLabel.text = localEMRLine.direction
        modelLabel.text = localEMRLine.model
                
        //TODO extra fields
        
        
        
        //TODO Test Replace attachment button
        if localEMRLine.emrId == "EMR003242" {
            replaceAttachmentView.isHidden = true
        } else {
            replaceAttachmentView.isHidden = false
        }
        
        
    }

}
