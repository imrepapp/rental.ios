//
//  ReplaceAttachmentViewController.swift
//  Rental
//
//  Created by Krisztián KORPA on 2019. 01. 07..
//  Copyright © 2019. Krisztián KORPA. All rights reserved.
//

import UIKit

class ReplaceAttachmentViewController: UIViewController {

    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var emrLabel: UILabel!
    
    @IBOutlet weak var selectAttachmentButtonOutlet: UIButton!
    @IBOutlet weak var selectReasonButtonOutlet: UIButton!
    @IBOutlet weak var selectReasonPickerView: UIPickerView!
    
    var localEMRLine: EMRLine!
    var selectedAttachment: ReplaceAttachment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        
        attachmentLabel.text = localEMRLine.eqId
        emrLabel.text = localEMRLine.emrId
        selectReasonPickerView.isHidden = true
        
        if selectedAttachment != nil {
            selectAttachmentButtonOutlet.setTitle(selectedAttachment?.eqId, for: .normal)
        }
        
    }

    
    @IBAction func selectAttachmentButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ReplaceAttachmentToAttachmentShow", sender: self)
    }
    
    @IBAction func selectReasonButtonPressed(_ sender: Any) {
        selectReasonPickerView.isHidden = !selectReasonPickerView.isHidden
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReplaceAttachmentToAttachmentShow" {

            let attachmentVC = segue.destination as! AttachmentsViewController
            
            attachmentVC.localEMRLine = self.localEMRLine
            
        }
    }
    
}
